float test_arr[4] = {3.12, 0.77, 7.88, -1.92};

float mul(int *);

int main(){
    float ret;
    int arr[4] = {1, 0, 1, 0};
    ret = mul(arr);
    return 0;
}

float mul(int *arr) {
    float tmp;
    for (int i = 0; i < 4; ++i) {
        tmp += arr[i] * test_arr[i];
    }
    return tmp;
}




