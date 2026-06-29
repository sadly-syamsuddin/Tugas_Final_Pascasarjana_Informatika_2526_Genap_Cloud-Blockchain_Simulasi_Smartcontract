// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

/**
 * @title Sistem Manajemen Riwayat Akademik Mahasiswa Berbasis Blockchain
 * @author Hafid - Universitas DIPA Makassar
 * @notice Simulasi penyimpanan dan verifikasi data akademik mahasiswa secara transparan dan tidak bisa dimanipulasi
 * @dev Deploy di Remix IDE menggunakan kompiler Solidity ^0.8.0
 */
contract AkademikBlockchain {

    // =============================================
    // STRUKTUR DATA
    // =============================================

    struct MataKuliah {
        string kodeMK;       // Contoh: "IF101"
        string namaMK;       // Contoh: "Pemrograman Web"
        uint8 sks;           // Jumlah SKS
        string nilai;        // A, B+, B, C+, C, D, E
        uint16 tahunAjaran;  // Contoh: 2024
        string semester;     // "Ganjil" atau "Genap"
    }

    struct Mahasiswa {
        string nim;
        string nama;
        string programStudi;
        string angkatan;
        bool terdaftar;
        uint256 totalMataKuliah;
    }

    // =============================================
    // STATE VARIABLES
    // =============================================

    address public admin;
    string public namaUniversitas;

    // Mapping NIM => data mahasiswa
    mapping(string => Mahasiswa) private dataMahasiswa;

    // Mapping NIM => daftar mata kuliah
    mapping(string => MataKuliah[]) private riwayatAkademik;

    // Mapping address => apakah verifikator resmi (perusahaan/instansi)
    mapping(address => bool) public verifikatorResmi;

    // Mapping NIM => apakah ijazah sudah diterbitkan
    mapping(string => bool) public statusIjazah;

    // Daftar semua NIM yang terdaftar
    string[] private daftarNIM;

    // =============================================
    // EVENTS
    // =============================================

    event MahasiswaTerdaftar(string indexed nim, string nama, uint256 timestamp);
    event NilaiDitambahkan(string indexed nim, string kodeMK, string nilai, uint256 timestamp);
    event IjazahDiterbitkan(string indexed nim, string nama, uint256 timestamp);
    event VerifikatorDitambahkan(address indexed verifikator, uint256 timestamp);
    event VerifikasiDilakukan(address indexed verifikator, string indexed nim, uint256 timestamp);

    // =============================================
    // MODIFIER
    // =============================================

    modifier hanyaAdmin() {
        require(msg.sender == admin, "Akses ditolak: hanya admin universitas");
        _;
    }

    modifier mahasiswaTerdaftar(string memory nim) {
        require(dataMahasiswa[nim].terdaftar, "Mahasiswa tidak ditemukan dalam sistem");
        _;
    }

    modifier hanyaVerifikatorResmi() {
        require(
            verifikatorResmi[msg.sender] || msg.sender == admin,
            "Akses ditolak: bukan verifikator resmi"
        );
        _;
    }

    // =============================================
    // CONSTRUCTOR
    // =============================================

    constructor(string memory _namaUniversitas) {
        admin = msg.sender;
        namaUniversitas = _namaUniversitas;
    }

    // =============================================
    // FUNGSI ADMIN - MANAJEMEN UNIVERSITAS
    // =============================================

    /**
     * @notice Daftarkan mahasiswa baru ke sistem
     * @param nim Nomor Induk Mahasiswa
     * @param nama Nama lengkap mahasiswa
     * @param programStudi Program studi (contoh: "Informatika")
     * @param angkatan Tahun angkatan (contoh: "2021")
     */
    function daftarkanMahasiswa(
        string memory nim,
        string memory nama,
        string memory programStudi,
        string memory angkatan
    ) public hanyaAdmin {
        require(!dataMahasiswa[nim].terdaftar, "NIM sudah terdaftar dalam sistem");
        require(bytes(nim).length > 0, "NIM tidak boleh kosong");
        require(bytes(nama).length > 0, "Nama tidak boleh kosong");

        dataMahasiswa[nim] = Mahasiswa({
            nim: nim,
            nama: nama,
            programStudi: programStudi,
            angkatan: angkatan,
            terdaftar: true,
            totalMataKuliah: 0
        });

        daftarNIM.push(nim);

        emit MahasiswaTerdaftar(nim, nama, block.timestamp);
    }

    /**
     * @notice Tambahkan nilai mata kuliah ke riwayat akademik mahasiswa
     * @param nim NIM mahasiswa
     * @param kodeMK Kode mata kuliah
     * @param namaMK Nama mata kuliah
     * @param sks Jumlah SKS
     * @param nilai Nilai huruf (A/B+/B/C+/C/D/E)
     * @param tahunAjaran Tahun ajaran (contoh: 2024)
     * @param semester "Ganjil" atau "Genap"
     */
    function tambahNilai(
        string memory nim,
        string memory kodeMK,
        string memory namaMK,
        uint8 sks,
        string memory nilai,
        uint16 tahunAjaran,
        string memory semester
    ) public hanyaAdmin mahasiswaTerdaftar(nim) {
        require(sks > 0 && sks <= 6, "SKS harus antara 1-6");
        require(bytes(kodeMK).length > 0, "Kode MK tidak boleh kosong");

        MataKuliah memory mk = MataKuliah({
            kodeMK: kodeMK,
            namaMK: namaMK,
            sks: sks,
            nilai: nilai,
            tahunAjaran: tahunAjaran,
            semester: semester
        });

        riwayatAkademik[nim].push(mk);
        dataMahasiswa[nim].totalMataKuliah++;

        emit NilaiDitambahkan(nim, kodeMK, nilai, block.timestamp);
    }

    /**
     * @notice Terbitkan ijazah digital untuk mahasiswa yang sudah lulus
     * @param nim NIM mahasiswa yang lulus
     */
    function terbitkanIjazah(string memory nim)
        public
        hanyaAdmin
        mahasiswaTerdaftar(nim)
    {
        require(!statusIjazah[nim], "Ijazah sudah pernah diterbitkan");
        require(dataMahasiswa[nim].totalMataKuliah > 0, "Mahasiswa belum memiliki riwayat nilai");

        statusIjazah[nim] = true;

        emit IjazahDiterbitkan(nim, dataMahasiswa[nim].nama, block.timestamp);
    }

    /**
     * @notice Tambahkan perusahaan/instansi sebagai verifikator resmi
     * @param alamatVerifikator Alamat wallet verifikator
     */
    function tambahVerifikator(address alamatVerifikator) public hanyaAdmin {
        require(alamatVerifikator != address(0), "Alamat tidak valid");
        verifikatorResmi[alamatVerifikator] = true;

        emit VerifikatorDitambahkan(alamatVerifikator, block.timestamp);
    }

    /**
     * @notice Cabut hak akses verifikator
     * @param alamatVerifikator Alamat wallet verifikator yang dicabut
     */
    function cabutVerifikator(address alamatVerifikator) public hanyaAdmin {
        verifikatorResmi[alamatVerifikator] = false;
    }

    // =============================================
    // FUNGSI VERIFIKASI - UNTUK PERUSAHAAN
    // =============================================

    /**
     * @notice Verifikasi data akademik mahasiswa (untuk perusahaan/instansi)
     * @param nim NIM mahasiswa yang ingin diverifikasi
     * @return nama Nama mahasiswa
     * @return programStudi Program studi
     * @return angkatan Tahun angkatan
     * @return totalMataKuliah Jumlah mata kuliah yang ditempuh
     * @return sudahIjazah Status ijazah
     */
    function verifikasiMahasiswa(string memory nim)
        public
        hanyaVerifikatorResmi
        mahasiswaTerdaftar(nim)
        returns (
            string memory nama,
            string memory programStudi,
            string memory angkatan,
            uint256 totalMataKuliah,
            bool sudahIjazah
        )
    {
        emit VerifikasiDilakukan(msg.sender, nim, block.timestamp);

        Mahasiswa memory mhs = dataMahasiswa[nim];
        return (
            mhs.nama,
            mhs.programStudi,
            mhs.angkatan,
            mhs.totalMataKuliah,
            statusIjazah[nim]
        );
    }

    /**
     * @notice Lihat seluruh riwayat nilai akademik mahasiswa
     * @param nim NIM mahasiswa
     * @return Array MataKuliah berisi seluruh riwayat nilai
     */
    function lihatRiwayatAkademik(string memory nim)
        public
        view
        hanyaVerifikatorResmi
        mahasiswaTerdaftar(nim)
        returns (MataKuliah[] memory)
    {
        return riwayatAkademik[nim];
    }

    // =============================================
    // FUNGSI PUBLIK - SIAPAPUN BISA AKSES
    // =============================================

    /**
     * @notice Cek apakah ijazah seseorang valid (bisa dicek siapapun)
     * @param nim NIM mahasiswa
     * @return valid True jika ijazah valid, false jika belum/tidak ada
     */
    function cekValiditasIjazah(string memory nim)
        public
        view
        returns (bool valid, string memory pesan)
    {
        if (!dataMahasiswa[nim].terdaftar) {
            return (false, "NIM tidak ditemukan dalam sistem universitas");
        }
        if (!statusIjazah[nim]) {
            return (false, "Ijazah belum diterbitkan atau tidak valid");
        }
        return (true, "Ijazah VALID - terdaftar dalam blockchain universitas");
    }

    /**
     * @notice Lihat informasi dasar mahasiswa (publik)
     * @param nim NIM mahasiswa
     */
    function infoMahasiswa(string memory nim)
        public
        view
        mahasiswaTerdaftar(nim)
        returns (
            string memory nama,
            string memory programStudi,
            string memory angkatan,
            bool ijazahDiterbitkan
        )
    {
        Mahasiswa memory mhs = dataMahasiswa[nim];
        return (mhs.nama, mhs.programStudi, mhs.angkatan, statusIjazah[nim]);
    }

    /**
     * @notice Dapatkan jumlah total mahasiswa yang terdaftar
     */
    function totalMahasiswa() public view returns (uint256) {
        return daftarNIM.length;
    }

    /**
     * @notice Dapatkan informasi kontrak ini
     */
    function infoSistem() public view returns (
        string memory universitas,
        address alamatAdmin,
        uint256 jumlahMahasiswa
    ) {
        return (namaUniversitas, admin, daftarNIM.length);
    }
}
