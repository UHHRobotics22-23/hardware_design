import cv2
import pykinect_azure as pykinect
import numpy as np
import time

# cv inRange somehow does not work
def inRange(img, lower, upper):
    return (img[:,:,0] >= lower[0]) & (img[:,:,0] <= upper[0]) & (img[:,:,1] >= lower[1]) & (img[:,:,1] <= upper[1]) & (img[:,:,2] >= lower[2]) & (img[:,:,2] <= upper[2])

if __name__ == "__main__":
    
    f = open(f"calibration-{time.time()}.csv", "w")

    # Initialize the library, if the library is not found, add the library path as argument
    pykinect.initialize_libraries()

    # Modify camera configuration
    device_config = pykinect.default_configuration
    device_config.color_format = pykinect.K4A_IMAGE_FORMAT_COLOR_BGRA32
    device_config.color_resolution = pykinect.K4A_COLOR_RESOLUTION_720P
    device_config.depth_mode = pykinect.K4A_DEPTH_MODE_NFOV_UNBINNED
    # print(device_config)

    # Start device
    device = pykinect.start_device(config=device_config)

    # Initialize the Open3d visualizer
    #open3dVisualizer = Open3dVisualizer()

    #cv2.namedWindow('Transformed color',cv2.WINDOW_NORMAL)
    last_distances = []
    
    while True:

        # Get capture
        capture = device.update()
        data_time = time.time()

        # Get the 3D point cloud
        ret_point, points = capture.get_transformed_pointcloud()

        # Get the color image in the depth camera axis
        ret_color, color_image = capture.get_color_image()

        if not ret_color or not ret_point:
            continue

        # find red points in the image using hsv
        hsv_image = cv2.cvtColor(color_image, cv2.COLOR_BGR2HSV)
        #redLower = (0, 0, 40, 255)
        #redUpper = (120, 120, 255, 255)
        #print(min(hsv_image[:,:,0].flatten()), max(hsv_image[:,:,1].flatten()), max(hsv_image[:,:,2].flatten()))
        redLower = (0, 114, 114)
        redUpper = (5, 255, 255)
        mask = cv2.inRange(hsv_image, redLower, redUpper)
        redLower2 = (175, 114, 114)
        redUpper2 = (180, 255, 255)
        mask2 = cv2.inRange(hsv_image, redLower2, redUpper2)
        mask = mask | mask2
        
        mask = np.array(mask, dtype=np.uint8)
        mask = cv2.erode(mask, None, iterations=1)
        mask = cv2.dilate(mask, None, iterations=1)
  
        # filter all with to little red to grey


        # remove all colors but red
        output = cv2.bitwise_and(color_image, color_image, mask=mask)

        cv2.imshow('Red Mask', output)
        cv2.imshow('Color Img', color_image)
        # red channel mask
        
        redImage = color_image.copy()
        redImage[:,:,0] = 0
        redImage[:,:,1] = 0
        redImage[:,:,2] = redImage[:,:,2]
        cv2.imshow('Red channel', redImage)
        
        # get point cloud data from red points
        redPoints = points[mask.flatten()==255]
        nonZero = np.array([point for point in redPoints if point[0] != 0 and point[1] != 0 and point[2] != 0])
        
        # Do full distance calc, discard low and average high values
        if nonZero.shape[0] > 300:
            print("Distrubed")
        else:
            count = 0   
            distances = []
            for i in range(nonZero.shape[0]):
                for j in range(i+1, nonZero.shape[0]):
                    distance = np.linalg.norm(nonZero[i]-nonZero[j])
                    if distance > 20:
                        count += 1
                        distances.append(distance)
            
            #print(distances)
            dist_std = np.std(distances)
            dist_mean = np.mean(distances)
            distances = [dist for dist in distances if dist > dist_mean - dist_std]
            
            
            if len(distances):
                last_distances += [np.mean(distances)]

            if len(last_distances) > 20:                                                        
                last_distances = last_distances[1:]
            
            # filter min and max
            dist_std = np.std(last_distances)
            dist_mean = np.mean(last_distances)
            considered_distances = [dist for dist in last_distances if dist > dist_mean - dist_std and dist < dist_mean + dist_std]
            distance_mean = np.mean(distances)
            print(distance_mean)
            f.write(f"{data_time},{distance_mean}\n")
        
        # Press q key to stop
        if cv2.waitKey(1) == ord('q'):  
            break
    f.close()