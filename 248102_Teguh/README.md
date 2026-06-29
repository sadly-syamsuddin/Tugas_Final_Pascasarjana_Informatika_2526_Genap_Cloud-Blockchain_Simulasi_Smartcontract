# ♻️ SampahPay Smart Contract

SampahPay adalah startup **GreenTech** yang memanfaatkan **Cloud Computing** dan **Blockchain** untuk mendukung pengelolaan sampah yang transparan, efisien, dan berbasis reward. Repository ini berisi implementasi sederhana **Smart Contract** menggunakan **Solidity** sebagai bukti konsep (Proof of Concept) dalam mengotomatisasi proses transaksi setoran sampah.

## 📌 Latar Belakang

Pengelolaan sampah di Indonesia masih menghadapi berbagai tantangan, seperti:

* Rendahnya kesadaran masyarakat dalam memilah sampah.
* Pencatatan transaksi bank sampah yang masih manual.
* Kurangnya transparansi dalam pemberian reward.
* Sulitnya melakukan audit terhadap transaksi sampah.

SampahPay hadir sebagai solusi digital yang menghubungkan masyarakat, kolektor, dan bank sampah dalam satu platform.

---

# 🚀 Fitur Smart Contract

Smart contract ini memiliki beberapa fungsi utama:

* ✅ Membuat transaksi setoran sampah
* ✅ Konfirmasi berat sampah oleh kolektor
* ✅ Perhitungan reward otomatis
* ✅ Perubahan status transaksi
* ✅ Melihat detail transaksi

---

# 🏗️ Arsitektur

```text
                   +----------------+
                   |     User       |
                   +-------+--------+
                           |
                    Create Transaction
                           |
                           v
                  +------------------+
                  | Smart Contract   |
                  | Status: Created  |
                  +--------+---------+
                           |
                    Confirm Weight
                           |
                           v
                  +------------------+
                  | Calculate Reward |
                  +--------+---------+
                           |
                    Release Reward
                           |
                           v
                  +------------------+
                  | Status Rewarded  |
                  +------------------+
```

---

# 📋 Transaction Status

| Status    | Deskripsi                           |
| --------- | ----------------------------------- |
| Created   | Transaksi baru dibuat oleh pengguna |
| Confirmed | Berat sampah telah diverifikasi     |
| Rewarded  | Reward telah diberikan              |

---

# 💰 Reward Rules

| Waste Type | Reward       |
| ---------- | ------------ |
| Plastic    | Rp2.000 / Kg |
| Paper      | Rp1.500 / Kg |
| Can        | Rp3.000 / Kg |
| Other      | Rp1.000 / Kg |

---

# ⚙️ Cara Menjalankan

## 1. Buka Remix IDE

https://remix.ethereum.org

## 2. Buat File Baru

```text
SampahPay.sol
```

## 3. Salin Source Code

Salin seluruh kode Solidity ke dalam file tersebut.

## 4. Compile

* Compiler Version : **0.8.20**
* Klik **Compile**

## 5. Deploy

* Environment : Remix VM
* Klik **Deploy**

---

# 🧪 Contoh Pengujian

## Membuat Transaksi

```solidity
createTransaction("Plastic");
```

Output

```
Transaction ID : 1
Status         : Created
```

---

## Konfirmasi Berat

```solidity
confirmWeight(1,5);
```

Hasil

```
Weight : 5 Kg
Reward : Rp10.000
Status : Confirmed
```

---

## Memberikan Reward

```solidity
releaseReward(1);
```

Output

```
Status : Rewarded
```

---

## Melihat Data

```solidity
getTransaction(1);
```

Output

```
ID
User
Waste Type
Weight
Reward
Status
```

---

# 🔄 Alur Bisnis

```text
User
 │
 │ Membuat transaksi
 ▼
Created
 │
 │
Collector
 │
 │ Konfirmasi berat
 ▼
Confirmed
 │
 │ Reward dihitung otomatis
 ▼
Rewarded
```

---

# ☁️ Integrasi Cloud & Blockchain

### Cloud Computing

Digunakan untuk menyimpan:

* Data pengguna
* Jadwal pickup
* Data bank sampah
* Foto bukti
* Dashboard
* Reward
* Riwayat transaksi

### Blockchain

Digunakan untuk mencatat:

* Transaction ID
* Waste Type
* Weight
* Reward
* Timestamp
* Transaction Status
* Hash bukti transaksi

---

# ⚠️ Risiko

Beberapa risiko implementasi:

* Kesalahan input berat sampah.
* Bug pada smart contract.
* Biaya gas blockchain.
* Manipulasi data apabila tidak dilakukan validasi.

### Mitigasi

* Validasi oleh kolektor.
* Hash transaksi disimpan di blockchain.
* Audit berkala.
* Role-based access control.

---

# 🛠️ Teknologi

* Solidity ^0.8.20
* Ethereum
* Remix IDE
* Cloud Computing (Concept)
* Blockchain
* Smart Contract

---

# 📚 Studi Kasus

Repository ini dibuat sebagai implementasi sederhana pada startup **SampahPay**, yaitu platform digital pengelolaan sampah berbasis **Cloud Computing** dan **Blockchain** yang bertujuan meningkatkan transparansi transaksi, efisiensi operasional, dan pemberian reward kepada masyarakat.

---

# 👨‍💻 Author

**Muh Teguh Adhi Putra**

**NIM : 248102**

Program Studi Teknik Informatika

Universitas Dipa Makassar
