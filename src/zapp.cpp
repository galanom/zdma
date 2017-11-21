#include <string>
#include <iostream>

#include <libzdma.h>

#include <cassert>
#include <ctime>
#include <cstdlib> // just for size_t !
#include <cstdio>
#include <cerrno>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "macro.h"

#define DEV_FILE "/dev/zdma"
#define IMG_FILE "./sample.jpg"

using namespace cv;
using namespace std;

int tdiff(struct timespec t1, struct timespec t0)
{
	return (t1.tv_sec - t0.tv_sec)*K + (t1.tv_nsec - t0.tv_nsec)/M;
}



int main(int argc, char **argv)
{
	bool verify = false;
	int err, task_num = 0, iter_num = 0, kern = 0;
	if (argc >= 3) {
		task_num = atoi(argv[1]);
		iter_num = atoi(argv[2]);
	}
	if (!task_num) task_num = 1;
	if (!iter_num) iter_num = 1;
	if (!kern) kern = 5;
	if (argc == 4) verify = true;

	zdma_core_register("sharpen");
	zdma_core_register("gauss");
	Mat img = imread("./sample.jpg", CV_LOAD_IMAGE_GRAYSCALE);
	if (!img.data) {
		cout << "Failed to load image \"" << IMG_FILE << "\", exiting." << endl;
		return -1;
	}
	int img_size = img.rows * img.cols;
	cout << "Loaded image \"" << IMG_FILE << "\", size: " << img_size << endl;
	Mat out[task_num];

	struct timespec t0, t1;
	struct zdma_task task[task_num];
//	cout << "Running " << task_num << " tasks by " << iter_num 
//		<< " times, verify is " << (verify ? "true" : "false") << "." << endl;
	for (int j = 0; j < task_num; ++j) {
		out[j].create(img.size(), img.type());
		err = zdma_task_init(&task[j]);
		assert(!err);
		err = zdma_task_configure(&task[j], "gauss", img_size, img_size, 1, img.cols);
		assert(!err);
		memcpy(task[j].tx_buf, img.data, img_size);
	}

//	zdma_debug();
	clock_gettime(CLOCK_MONOTONIC, &t0);
	#pragma omp parallel num_threads(task_num)
	for (int i = 0; i < iter_num; ++i) {
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_enqueue(&task[j]);
			assert(!err);
		}
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_waitfor(&task[j]);
			if (verify) {
				memcpy(out[j].data, task[j].rx_buf, img_size);
				imwrite("out" + to_string(j) + ".jpg", out[j]);
			}
		}
	}
	clock_gettime(CLOCK_MONOTONIC, &t1);
	for (int j = 0; j < task_num; ++j)
		zdma_task_destroy(&task[j]);
	int t = tdiff(t1, t0);
	cout << "Exec: " << task_num << " tasks by " << iter_num << " times, time: " 
		<< t/1000 << "." << t%1000 << ", throughput: " << 
		task_num*iter_num*img_size/(t*1000.0) << "MiB/s" << endl;
	return 0;
}

