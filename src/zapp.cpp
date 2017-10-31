#include <libzdma.h>
#include <cassert>
#include <ctime>
#include <cstdlib> // just for size_t !
#include <cerrno>
//#include <opencv2/core/core.hpp>
//#include <opencv2/highgui/highgui.hpp>
//#include <opencv2/imgproc/imgproc.hpp>

#include "macro.h"

#define DEV_FILE "/dev/zdma"
#define SIZE (768*1024)

//using namespace cv;

int tdiff(struct timespec t1, struct timespec t0)
{
	return (t1.tv_sec - t0.tv_sec)*K + (t1.tv_nsec - t0.tv_nsec)/M;
}



int main(int argc, char **argv)
{
	bool verify = false;
	int err, task_num = 0, iter_num = 0;
	if (argc >= 3) {
		task_num = atoi(argv[1]);
		iter_num = atoi(argv[2]);
	}
	if (!task_num) task_num = 1;
	if (!iter_num) iter_num = 1;
	if (argc == 4) verify = true;

	zdma_core_register("loopback", "./loopback.bit");
	zdma_core_register("cvloopback", "./loopback.bit");
//	Mat src = imread("./test_1080.bmp");

	struct timespec t0, t1;
	struct zdma_task task[task_num];
	for (int j = 0; j < task_num; ++j) {
		err = zdma_task_init(&task[j]);
		assert(!err);
//		if (j < task_num/2)
			err = zdma_task_configure(&task[j], "loopback", SIZE, SIZE, 0);
//		else
//			err = zdma_task_configure(&task[j], "cvloopback", -1, -1, 0); 
		assert(!err);
	}

	zdma_debug();
	clock_gettime(CLOCK_MONOTONIC, &t0);
	#pragma omp parallel num_threads(task_num)
	for (int i = 0; i < iter_num; ++i) {
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_enqueue(&task[j]);
			///assert(!err);
		}
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err= zdma_task_waitfor(&task[j]);
			//assert(!err);
			if (verify) zdma_task_verify(&task[j]);
		}
	}
	clock_gettime(CLOCK_MONOTONIC, &t1);
	for (int j = 0; j < task_num; ++j)
		zdma_task_destroy(&task[j]);
	//int t = tdiff(t1, t0);
	//printf("Exec: %d tasks by %d times, time: %d.%d, %.2fMB/s\n", 
	//	task_num, iter_num, t/1000, t%1000, task_num*iter_num*SIZE/(t*1000.0));
	return 0;
}

