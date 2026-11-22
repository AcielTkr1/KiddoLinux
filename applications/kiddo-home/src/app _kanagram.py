
import tkinter as tk
import random

# Kumpulan soal dan petunjuk
data = {
    "APEL": "Buah yang memiliki warna merah atau hijau",
    "BUKU": "Benda yang digunakan untuk membaca",
    "MEJA": "Tempat untuk menulis",
    "KUCING": "Hewan yang suka mengeong",
    "BUNGA": "Tumbuhan yang memiliki kelopak indah",
    "PISANG": "Buah berwarna kuning",
    "SEKOLAH": "Tempat untuk belajar"
}

skor = 0
jawaban = ""
sudah_benar = False

# Membuat soal baru
def soal_baru():
    global jawaban, sudah_benar

    jawaban = random.choice(list(data.keys()))
    huruf = list(jawaban)

    # Mengacak huruf
    while True:
        random.shuffle(huruf)
        if "".join(huruf) != jawaban:
            break

    soal.config(text="  ".join(huruf))
    petunjuk.config(text=data[jawaban])

    input_jawaban.delete(0, tk.END)
    hasil.config(text="Ayo tebak kata yang benar!")
    sudah_benar = False


# Memeriksa jawaban
def periksa():
    global skor, sudah_benar

    if sudah_benar:
        hasil.config(text="Klik soal berikutnya!")
        return

    tebakan = input_jawaban.get().strip().upper()

    if tebakan == "":
        hasil.config(text="Masukkan jawaban terlebih dahulu!")
        return

    if tebakan == jawaban:
        skor += 10
        nilai.config(text="Skor: " + str(skor))
        hasil.config(text="Hebat! Jawaban kamu benar!")
        sudah_benar = True
    else:
        hasil.config(text="Belum tepat. Coba lagi ya!")


# Membuat jendela utama
root = tk.Tk()
root.title("Kanagram Kids")
root.geometry("450x400")
root.configure(bg="#DDF2FF")
root.resizable(False, False)

# Judul aplikasi
judul = tk.Label(
    root,
    text="KANAGRAM KIDS",
    font=("Arial", 22, "bold"),
    bg="#DDF2FF",
    fg="#24527A"
)
judul.pack(pady=20)

# Instruksi permainan
instruksi = tk.Label(
    root,
    text="Susun huruf berikut menjadi kata yang benar!",
    font=("Arial", 11),
    bg="#DDF2FF"
)
instruksi.pack()

# Huruf acak
soal = tk.Label(
    root,
    text="",
    font=("Arial", 25, "bold"),
    bg="#DDF2FF",
    fg="#FF7043"
)
soal.pack(pady=15)

# Petunjuk
petunjuk = tk.Label(
    root,
    text="",
    font=("Arial", 11),
    bg="#DDF2FF"
)
petunjuk.pack(pady=5)

# Kolom jawaban
input_jawaban = tk.Entry(
    root,
    font=("Arial", 16),
    justify="center",
    width=20
)
input_jawaban.pack(pady=15)

# Tombol periksa
tombol_periksa = tk.Button(
    root,
    text="Periksa Jawaban",
    font=("Arial", 11, "bold"),
    bg="#73C2FB",
    command=periksa
)
tombol_periksa.pack(pady=5)

# Hasil jawaban
hasil = tk.Label(
    root,
    text="",
    font=("Arial", 11, "bold"),
    bg="#DDF2FF"
)
hasil.pack(pady=10)

# Skor
nilai = tk.Label(
    root,
    text="Skor: 0",
    font=("Arial", 12, "bold"),
    bg="#DDF2FF"
)
nilai.pack()

# Tombol soal berikutnya
tombol_berikutnya = tk.Button(
    root,
    text="Soal Berikutnya",
    font=("Arial", 11, "bold"),
    bg="#90EE90",
    command=soal_baru
)
tombol_berikutnya.pack(pady=15)

# Menjalankan soal pertama
soal_baru()

# Menjalankan aplikasi
root.mainloop()
