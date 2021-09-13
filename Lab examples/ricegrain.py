import numpy as np
import cv2

def reject_borders(image_):
    out_image = image_.copy()
    h, w = image_.shape[:2]
    for row in range(h):
        if out_image[row, 0] == 255:
            cv2.floodFill(out_image, None, (0, row), 0)
        if out_image[row, w - 1] == 255:
            cv2.floodFill(out_image, None, (w - 1, row), 0)
    for col in range(w):
        if out_image[0, col] == 255:
            cv2.floodFill(out_image, None, (col, 0), 0)
        if out_image[h - 1, col] == 255:
            cv2.floodFill(out_image, None, (col, h - 1), 0)
    return out_image

# Load an color image in grayscale
img = cv2.imread(r"G:\\My Drive\\1. EIT Digital master\\Estland\\Semester 1\\Machine vision\\Lab\\rice.png", 0)

cv2.imshow("image", img)

#similar to flatfield correction CLAHE (Contrast Limited Adaptive Histogram Equalization)
clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
cl1 = clahe.apply(img)

cv2.imshow("Clahe img", cl1)


#thresholding
#https://medium.com/@sumandeep.banerjee/counting-grains-of-rice-corona-quarantine-blues-44eaba6d3598
ret,thresh1 = cv2.threshold(cl1,127,255, cv2.THRESH_BINARY)

cv2.imshow("Threshold img", thresh1)

#erode image
kernel = np.ones((4,4), dtype = np.uint8)
#kernel = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]], dtype = np.uint8)
#print(kernel)

eroded = cv2.erode(thresh1, kernel)
cv2.imshow("Eroded img", eroded)

#remove border components https://stackoverflow.com/questions/66527607/remove-objects-that-touch-an-image-borders
borderless = reject_borders(eroded)

#count objects
contours, hierarchy = cv2.findContours(borderless, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

cv2.imshow("%d objects" %len(contours), borderless)
cv2.waitKey(0) #to render image in vscode
