import cv2

pic = cv2.imread("./hxw.png")
data_out = open("./out.asm", "w")

start_x = 0xB0
start_y = 0x0

data_out.write("PIC_DATA_EN: \n")
data_out.write(".word 0x01FF \n")
data_out.write("PIC_DATA_X: \n")
data_out.write(".word 0x80 \n")
data_out.write("PIC_DATA_Y: \n")
data_out.write(".word 0x0 \n")

data_out.write("PIC_DATA_COLOR_ARRAY: \n")

pic = cv2.resize(pic, (80, 80))
h, w, _ = pic.shape

cv2.imshow("test", pic)

cv2.waitKey(0)


for i in range(h):
    for j in range(w):
        data_int = int(pic[i][j][2] / 32) * 64 + int(pic[i][j][1] / 32) * 8 + int(pic[i][j][0] / 32)
        # print data_int
        data_hex = hex(data_int)
        data_out.write(".word " + data_hex + "\n")


data_out.close()
