# FPGA-with-FTDI-chip
Using UMFT601A-B from FTDI to implement data transfer between PC and FPGA.

# 硬體資訊
1. FPGA：DE2-115
2. FTDI：UMFT601A-B

## FTDI與FPGA的連結
FTDI與FPGA的接口叫做HSMC，如果要連結的話FPGA需要pin成FTDI需要的樣子。
1. 在[UMFT601的說明書](https://ftdichip.com/wp-content/uploads/2020/08/DS_UMFT60xx-module-datasheet.pdf)裡尋找UMFT601的訊號。

![image](https://user-images.githubusercontent.com/54358541/164283788-57af7ef1-a0f3-4776-845e-37f6a54cd805.png)


## 
