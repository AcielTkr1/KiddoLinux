
import tkinter as tk
import random

# ==================================
# 1. DATA SOAL DAN PETUNJUK
# ==================================

data = {
    "APEL": "Buah berwarna merah atau hijau",
    "BUKU": "Benda yang digunakan untuk membaca",
    "MEJA": "Tempat untuk menulis",
    "KUCING": "Hewan yang suka mengeong",
    "BUNGA": "Tumbuhan yang memiliki kelopak indah",
    "PISANG": "Buah yang berwarna kuning",
    "SEKOLAH": "Tempat untuk belajar",
    "MOBIL": "Kendaraan yang memiliki empat roda",
    "GITAR": "Alat musik yang dimainkan dengan dipetik",
    "MATAHARI": "Benda langit yang memberikan cahaya",
    "MATA": "Indra yang digunakan untuk melihat",
    "TANGAN": "Anggota tubuh yangdigumakan untuk memegang",
    "PELANGI": "Fenomena alam dengan banyak warna",
    "LAUT": "Perairan luas yang memiliki air asin",
    "KERETA": "Kendaraan yang berjalan di atas rel",
    "PESAWAT": "Kendaraan yang terbang di udara",
    "SEPEDA": "Kendaraan roda dua yang dikayuh",
    "PERAHU": "Kendaraan yang digunakan di perairan",
    "BUS": "Kendaraan umum yang mengangkut banyak penumpang",
    "KAPAL": "Kendaraan besar yang berlayar di laut",
    "MOTOR": "Kendaraan roda dua yang menggunakan mesin",
    "AMBULANS": "Kendaraan untuk membawa orang sakit",
    "SEPAKBOLA": "Olahraga yang dimainkan dengan menendang bola",
    "BULUTANGKIS": "Olahraga yang menggunakan raket dan kok",
    "RENANG": "Olahraga yang dilakukan di dalam air",
    "VOLI": "Olahraga yang menggunakan bola dan net",
    "BASKET": "Olahraga yang memasukkan bola ke keranjang",
    "LARI": "Olahraga yang dilakukan dengan bergerak cepat menggunakan kaki",
    "PANAH": "Olahraga yang menggunakan busur dan anak panah",
    "DOKTER": "Orang yang bertugas mengobati orang sakit",
    "GURU": "Orang yang mengajar murid di sekolah",
    "PILOT": "Orang yang bertugas menerbangkan pesawat",
    "PETANI": "Orang yang bekerja menanam tanaman",
    "POLISI": "Orang yang bertugas menjaga keamanan",
    "NELAYAN": "Orang yang bekerja menangkap ikan di laut",
    "KOKI": "Orang yang bertugas memasak makanan",
    "PEMADAM": "Orang yang bertugas memadamkan kebakaran"


    }

# ==================================
# 2. VARIABEL PERMAINAN
# ==================================

skor = 0
jawaban = ""
sudah_benar = False
daftar_soal = []

# ==================================
# 3. FUNGSI MEMULAI PERMAINAN
# ==================================

def mulai_permainan():
    global skor, daftar_soal, sudah_benar

    skor = 0
    sudah_benar = False

    # Mengacak urutan soal
    daftar_soal = list(data.keys())
    random.shuffle(daftar_soal)

    nilai.config(text="Skor: 0")

    tombol_periksa.config(state="normal")
    tombol_berikutnya.config(state="disabled")

    soal_baru()


# ==================================
# 4. FUNGSI MENAMPILKAN SOAL BARU
# ==================================

def soal_baru():
    global jawaban, sudah_benar

    # Memeriksa apakah semua soal sudah selesai
    if len(daftar_soal) == 0:

        soal.config(text="SELESAI!")
        petunjuk.config(text="Semua soal sudah kamu kerjakan!")
        hasil.config(
            text="Hebat! Selamat bermain!",
            fg="#16803C"
        )

        input_jawaban.delete(0, tk.END)

        tombol_periksa.config(state="disabled")
        tombol_berikutnya.config(state="disabled")

        return

    # Mengambil soal berikutnya
    jawaban = daftar_soal.pop()

    # Mengacak huruf
    huruf = list(jawaban)
    random.shuffle(huruf)

    # Memastikan susunan tidak sama dengan jawaban
    if len(jawaban) > 1:
        while "".join(huruf) == jawaban:
            random.shuffle(huruf)

    # Menampilkan huruf dan petunjuk
    soal.config(text="  ".join(huruf))
    petunjuk.config(text=data[jawaban])

    # Mengosongkan kolom jawaban
    input_jawaban.delete(0, tk.END)

    hasil.config(
        text="Ayo tebak kata yang benar!",
        fg="#24527A"
    )

    sudah_benar = False

    # Tombol periksa aktif
    tombol_periksa.config(state="normal")

    # Tombol berikutnya belum aktif
    tombol_berikutnya.config(state="disabled")

    input_jawaban.focus()


# ==================================
# 5. FUNGSI MEMERIKSA JAWABAN
# ==================================

def periksa():
    global skor, sudah_benar

    if sudah_benar:
        return

    tebakan = input_jawaban.get().strip().upper()

    # Jika jawaban kosong
    if tebakan == "":
        hasil.config(
            text="Masukkan jawaban terlebih dahulu!",
            fg="#E65100"
        )
        return

    # Jika jawaban benar
    if tebakan == jawaban:

        skor += 10

        nilai.config(text="Skor: " + str(skor))

        hasil.config(
            text="Hebat! Jawaban kamu benar!",
            fg="#16803C"
        )

        sudah_benar = True

        # Mengaktifkan tombol berikutnya
        tombol_berikutnya.config(state="normal")

        # Menonaktifkan tombol periksa
        tombol_periksa.config(state="disabled")

    # Jika jawaban salah
    else:
        hasil.config(
            text="Belum tepat. Coba lagi ya!",
            fg="#D32F2F"
        )


# ==================================
# 6. MEMBUAT JENDELA APLIKASI
# ==================================

root = tk.Tk()

root.title("Kanagram Kids")
root.geometry("500x500")
root.configure(bg="#DDF2FF")
root.resizable(False, False)


# ==================================
# 7. JUDUL APLIKASI
# ==================================

judul = tk.Label(
    root,
    text="KANAGRAM KIDS",
    font=("Arial", 24, "bold"),
    bg="#DDF2FF",
    fg="#24527A"
)

judul.pack(pady=20)


# ==================================
# 8. INSTRUKSI PERMAINAN
# ==================================

instruksi = tk.Label(
    root,
    text="Susun huruf berikut menjadi kata yang benar!",
    font=("Arial", 11),
    bg="#DDF2FF",
    fg="#333333"
)

instruksi.pack(pady=5)


# ==================================
# 9. TAMPILAN HURUF ACAK
# ==================================

soal = tk.Label(
    root,
    text="",
    font=("Arial", 28, "bold"),
    bg="#DDF2FF",
    fg="#FF7043"
)

soal.pack(pady=20)


# ==================================
# 10. PETUNJUK SOAL
# ==================================

petunjuk = tk.Label(
    root,
    text="",
    font=("Arial", 12),
    bg="#DDF2FF",
    fg="#24527A",
    wraplength=420
)

petunjuk.pack(pady=10)


# ==================================
# 11. KOLOM JAWABAN
# ==================================

input_jawaban = tk.Entry(
    root,
    font=("Arial", 17),
    justify="center",
    width=22
)

input_jawaban.pack(pady=15)


# ==================================
# 12. TOMBOL PERIKSA JAWABAN
# ==================================

tombol_periksa = tk.Button(
    root,
    text="Periksa Jawaban",
    font=("Arial", 11, "bold"),
    bg="#73C2FB",
    fg="black",
    width=20,
    command=periksa
)

tombol_periksa.pack(pady=7)


# ==================================
# 13. HASIL JAWABAN
# ==================================

hasil = tk.Label(
    root,
    text="",
    font=("Arial", 12, "bold"),
    bg="#DDF2FF"
)

hasil.pack(pady=10)


# ==================================
# 14. TAMPILAN SKOR
# ==================================

nilai = tk.Label(
    root,
    text="Skor: 0",
    font=("Arial", 14, "bold"),
    bg="#DDF2FF",
    fg="#24527A"
)

nilai.pack(pady=5)


# ==================================
# 15. TOMBOL SOAL BERIKUTNYA
# ==================================

tombol_berikutnya = tk.Button(
    root,
    text="Soal Berikutnya",
    font=("Arial", 11, "bold"),
    bg="#90EE90",
    fg="black",
    width=20,
    command=soal_baru,
    state="disabled"
)

tombol_berikutnya.pack(pady=7)


# ==================================
# 16. TOMBOL MAIN LAGI
# ==================================

tombol_main_lagi = tk.Button(
    root,
    text="Main Lagi",
    font=("Arial", 11, "bold"),
    bg="#FFD180",
    fg="black",
    width=20,
    command=mulai_permainan
)

tombol_main_lagi.pack(pady=7)


# ==================================
# 17. MENJALANKAN PERMAINAN
# ==================================

mulai_permainan()

root.mainloop()
