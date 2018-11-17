#include <iostream>
#include <iomanip>
#include <random>

#define NUMBER 19
#define Maxrand 100000.0
using namespace std;

void swap(float data[], int a, int b)
{
    float temp = data[a];
    data[a] = data[b];
    data[b] = temp;
}

void printArray(float data[], int low, int high)
{

    for (int i = low; i <= high; i++)
    {
        cout << data[i] << " ";
    }
    cout << endl;
}

void quickSort(float Data[], int l, int r)
{
    if (l <= r)
    {
        float key = Data[(l + r) / 2];

        int i = l;
        int j = r;

        while (i <= j)
        {
            while (Data[i] < key)
                i++;
            while (Data[j] > key)
                j--;

            if (i <= j)
            {
                swap(Data, i, j);
                i++;
                j--;
            }
        }

        if (l < j)
            quickSort(Data, l, j);
        if (r > i)
            quickSort(Data, i, r);
    }
}

int main()
{

    int nhap;
    cout << "Lua chon phuong an:" << endl
         << "1. Nhap vao mang." << endl
         << "2. Ramdom mot mang." << endl
         << "Lua chon phuong an: ";
    cin >> nhap;
    float data[NUMBER + 1];
    switch (nhap)
    {
    case 1:
    {
        int i = 0;
        while (i <= NUMBER)
        {
            cout << "Nhap vao phan tu thu " << i << ": ";
            cin >> data[i];
            i++;
        }
        break;
    }
    case 2:
    {
        int i = 0;
        srand(time(NULL));
        while (i <= NUMBER)
        {
            data[i] = -Maxrand + (Maxrand + Maxrand) * rand() / RAND_MAX;
            i++;
        }
        break;
    }
    default:
        cout << "Ban lua chon sai!" << endl;
    }

    cout << "Mang cua ban truoc khi su dung quickSort:" << endl;
    printArray(data, 0, NUMBER);

    quickSort(data, 0, NUMBER);

    cout << "Mang cua ban sau khi su dung quickSort:" << endl;
    printArray(data, 0, NUMBER);
    return 0;
}