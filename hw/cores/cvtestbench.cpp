#include "common.h"
#include "hls_opencv.h"
#include "cvtestbench.h"

using namespace cv;

#define INPUT_IMAGE           "test_1080p.bmp"
#define OUTPUT_IMAGE          "result_1080p.bmp"
#define OUTPUT_IMAGE_GOLDEN   "result_1080p_golden.bmp"


void opencv_image_filter(IplImage *src, IplImage *dst) {
    cvCopy(src, dst);
}

void hls_image_filter(IplImage *src, IplImage *dst) {
    axi_stream_t src_axi, dst_axi;
    IplImage2AXIvideo(src, src_axi);
    cvloopback(src_axi, dst_axi, src->height, src->width);
    AXIvideo2IplImage(dst_axi, dst);
}


int main (int argc, char** argv) {
//    const char * inputfile = argc >= 2 ? argv[1] : INPUT_IMAGE;
//    const char * goldenfile = argc >= 3 ? argv[2] : OUTPUT_IMAGE_GOLDEN;

    Mat src_rgb = imread(INPUT_IMAGE);
    if (!src_rgb.data) {
        printf("ERROR: could not open or find the input image!\n");
        return -1;
    }
    Mat src_yuv(src_rgb.rows, src_rgb.cols, CV_8UC2);
    Mat dst_yuv(src_rgb.rows, src_rgb.cols, CV_8UC2);
    Mat dst_rgb(src_rgb.rows, src_rgb.cols, CV_8UC3);

    cvtcolor_rgb2yuv422(src_rgb, src_yuv);

    IplImage src = src_yuv;
    IplImage dst = dst_yuv;
    hls_image_filter(&src, &dst);
    cvtColor(dst_yuv, dst_rgb, CV_YUV2BGR_YUYV);
    imwrite(OUTPUT_IMAGE, dst_rgb);

    opencv_image_filter(&src, &dst);
    cvtColor(dst_yuv, dst_rgb, CV_YUV2BGR_YUYV);
    imwrite(OUTPUT_IMAGE_GOLDEN, dst_rgb);

    return image_compare(OUTPUT_IMAGE, OUTPUT_IMAGE_GOLDEN);
}
