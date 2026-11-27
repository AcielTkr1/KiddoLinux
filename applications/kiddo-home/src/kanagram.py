import tkinter as tk
import random
import configparser
import os

from pathlib import Path

# ==================================
# PENGATURAN BAHASA KIDDO HOME
# ==================================

def baca_bahasa():

    config = configparser.ConfigParser()

    config_dir = Path(
        os.environ.get(
            "XDG_CONFIG_HOME",
            Path.home() / ".config"
        )
    )

    config_file = config_dir / "KiddoLinux" / "KiddoHome.conf"

    config.read(config_file)

    bahasa = config.get(
        "General",
        "language",
        fallback="id"
    )

    return bahasa


bahasa = baca_bahasa()


def tx(indonesia, english):
    if bahasa == "en":
        return english

    return indonesia
# ==================================
# 1. DATA SOAL DAN PETUNJUK
# ==================================

data = {
    "APEL": {
        "id": "Buah berwarna merah atau hijau",
        "en": "A fruit that can be red or green"
    },
    "BUKU": {
        "id": "Benda yang digunakan untuk membaca",
        "en": "Something you use to read"
    },
    "MEJA": {
        "id": "Tempat untuk menulis",
        "en": "Furniture used for writing"
    },
    "KUCING": {
        "id": "Hewan yang suka mengeong",
        "en": "An animal that likes to meow"
    },
    "BUNGA": {
        "id": "Tumbuhan yang memiliki kelopak indah",
        "en": "A plant with beautiful petals"
    },
    "PISANG": {
        "id": "Buah yang berwarna kuning",
        "en": "A fruit that is yellow"
    },
    "SEKOLAH": {
        "id": "Tempat untuk belajar",
        "en": "A place where students learn"
    },
    "MOBIL": {
        "id": "Kendaraan yang memiliki empat roda",
        "en": "A vehicle with four wheels"
    },
    "GITAR": {
        "id": "Alat musik yang dimainkan dengan dipetik",
        "en": "A musical instrument played by plucking strings"
    },
    "MATAHARI": {
        "id": "Benda langit yang memberikan cahaya",
        "en": "A celestial object that gives us light"
    },
    "MATA": {
        "id": "Indra yang digunakan untuk melihat",
        "en": "An organ used for seeing"
    },
    "TANGAN": {
        "id": "Anggota tubuh yang digunakan untuk memegang",
        "en": "A body part used for holding things"
    },
    "PELANGI": {
        "id": "Fenomena alam dengan banyak warna",
        "en": "A natural phenomenon with many colors"
    },
    "LAUT": {
        "id": "Perairan luas yang memiliki air asin",
        "en": "A large body of salt water"
    },
    "KERETA": {
        "id": "Kendaraan yang berjalan di atas rel",
        "en": "A vehicle that travels on railway tracks"
    },
    "PESAWAT": {
        "id": "Kendaraan yang terbang di udara",
        "en": "A vehicle that flies in the sky"
    },
    "SEPEDA": {
        "id": "Kendaraan roda dua yang dikayuh",
        "en": "A two-wheeled vehicle powered by pedaling"
    },
    "PERAHU": {
        "id": "Kendaraan yang digunakan di perairan",
        "en": "A small vehicle used on water"
    },
    "BUS": {
        "id": "Kendaraan umum yang mengangkut banyak penumpang",
        "en": "A public vehicle that carries many passengers"
    },
    "KAPAL": {
        "id": "Kendaraan besar yang berlayar di laut",
        "en": "A large vehicle that sails on the sea"
    },
    "MOTOR": {
        "id": "Kendaraan roda dua yang menggunakan mesin",
        "en": "A two-wheeled vehicle with an engine"
    },
    "AMBULANS": {
        "id": "Kendaraan untuk membawa orang sakit",
        "en": "A vehicle used to transport sick people"
    },
    "SEPAKBOLA": {
        "id": "Olahraga yang dimainkan dengan menendang bola",
        "en": "A sport played by kicking a ball"
    },
    "BULUTANGKIS": {
        "id": "Olahraga yang menggunakan raket dan kok",
        "en": "A sport played with a racket and a shuttlecock"
    },
    "RENANG": {
        "id": "Olahraga yang dilakukan di dalam air",
        "en": "A sport performed in water"
    },
    "VOLI": {
        "id": "Olahraga yang menggunakan bola dan net",
        "en": "A sport played with a ball and a net"
    },
    "BASKET": {
        "id": "Olahraga yang memasukkan bola ke keranjang",
        "en": "A sport where players throw a ball into a hoop"
    },
    "LARI": {
        "id": "Olahraga yang dilakukan dengan bergerak cepat menggunakan kaki",
        "en": "A sport that involves moving quickly on foot"
    },
    "PANAH": {
        "id": "Olahraga yang menggunakan busur dan anak panah",
        "en": "A sport that uses a bow and arrows"
    },
    "DOKTER": {
        "id": "Orang yang bertugas mengobati orang sakit",
        "en": "A person who treats sick people"
    },
    "GURU": {
        "id": "Orang yang mengajar murid di sekolah",
        "en": "A person who teaches students at school"
    },
    "PILOT": {
        "id": "Orang yang bertugas menerbangkan pesawat",
        "en": "A person who flies an aircraft"
    },
    "PETANI": {
        "id": "Orang yang bekerja menanam tanaman",
        "en": "A person who grows crops"
    },
    "POLISI": {
        "id": "Orang yang bertugas menjaga keamanan",
        "en": "A person who helps keep people safe"
    },
    "NELAYAN": {
        "id": "Orang yang bekerja menangkap ikan di laut",
        "en": "A person who catches fish in the sea"
    },
    "KOKI": {
        "id": "Orang yang bertugas memasak makanan",
        "en": "A person whose job is to cook food"
    },
    "PEMADAM": {
        "id": "Orang yang bertugas memadamkan kebakaran",
        "en": "A person whose job is to put out fires"
    }
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
    petunjuk.config(text=data[jawaban][bahasa])

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
