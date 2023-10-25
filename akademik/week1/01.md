# Minggu 01

## Hari 1: Swift, Ekosistem iOS, dan Dasar-dasar Pemrograman Swift

### Tujuan

1. Siswa bisa memahami keterkaitan antara bahasa pemrograman dengan *compiler/interpreter*.
2. Siswa memahami komponen dari peranti pengembangan (*development tools*) dan bisa mencari komponen-komponen untuk suatu bahasa pemrograman tertentu.

3. Siswa mampu menginstall Visual Xcode serta plugin untuk peranti pengembangan Swift. Siswa juga dibebaskan menggunakan editor teks maupun IDE lainnya.
4. Siswa memahami dan mampu membuat *source code* dalam bahasa pemrograman Swift serta menjalankan hasilnya  - menggunakan *swift playground*. 
5. Siswa memahami struktur dasar *source code* dalam bahasa pemrograman Swift.
6. Siswa memahmai dan bisa menggunakan komentar, variabel, konstanta, operator, ekspresi, statement, dan tipe data dasar di Swift.
7. Siswa memahami dan bisa menggunakan perintah-perintah Swift untuk mengatur alur kendali program.
8. Siswa memahami penggunaan interface di xcode

### Pembahasan

1. Development tools dan ekosistemnya
2. Dasar-dasar Swift: 
    * Instalasi Xcode.
    * pod dan carthage.
    * Konstruksi dasar bahasa pemrograman Swift: indentasi, komentar, variabel, konstanta, operator, ekspresi, *statement* / pernyataan, tipe data dasar. 
    * Pernyataan untuk mengatur alur kendali program
    * Penggunaan Playground untuk Mengetest Code Swift

### Pembelajaran

```
Materi dan Penjelasan
```

1. Keterkaitan antara [bahasa pemrograman](https://en.wikipedia.org/wiki/Programming_language), [compiler](https://en.wikipedia.org/wiki/Compiler), dan [interpreter](https://en.wikipedia.org/wiki/Interpreter_(computing)).
2. Komponen dari [peranti pengembangan (*development tools*)](https://en.wikipedia.org/wiki/Programming_tool) dan bisa mencari komponen-komponen untuk suatu bahasa pemrograman tertentu.
3. [Riwayat versi dari Swift](https://docs-swift-org.translate.goog/swift-book/documentation/the-swift-programming-language/revisionhistory/?_x_tr_sl=en&_x_tr_tl=id&_x_tr_hl=id&_x_tr_pto=tc&_x_tr_hist=true).
4. [Instalasi Xcode](https://developer.apple.com/documentation/safari-developer-tools/installing-xcode-and-simulators).
5. [Intalasi Brew](https://brew.sh).
6. [Instalasi Pod] (https://guides.cocoapods.org/using/pod-install-vs-update.html).
7. [Swift Tutorial - Basic](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/aboutswift).dan juga ada di(https://www.hackingwithswift.com/100)

```
Latihan
```

 Install Xcode.
2. Install Brew
2. Buatlah Plaground Swift.
3. Kerjakan point nomor 7 di materi dan penjelasan di atas menggunakan playground. Simpan hasilnya dan push ke repo.

```
Kasus
```

Setelah mempelajari berbagai [algoritma sorting](https://en.wikipedia.org/wiki/Sorting_algorithm), buat implementasi dari algoritma sorting tersebut, minimal 5 algoritma. Proses sorting dilakukan oleh suatu *function*.

<pre>
jawablah pertanyaan berikut dan tulis di readme.md 
1. Variabel dan Konstanta:
    Apa perbedaan antara variabel dan konstanta dalam Swift?
    Bagaimana Anda mendeklarasikan variabel dan konstanta dalam Swift?
    Apa itu "type inference," dan bagaimana ia berfungsi dalam deklarasi variabel?
    Bagaimana Anda mengubah nilai variabel yang telah dideklarasikan?
2. Enum:
    Apa itu enum (enumeration) dalam Swift, dan apa gunanya?
    Apa perbedaan antara enum dengan associated values dan enum dengan raw values?
    Bagaimana Anda mendefinisikan enum dengan kasus-kasus yang berbeda?
    Bagaimana Anda mengakses nilai-nilai yang terkait dengan kasus enum?
3. Kondisi:
    Apa yang dimaksud dengan pernyataan if, else if, dan else dalam Swift?
    Bagaimana Anda menggunakan pernyataan switch dalam Swift?
    Apa itu "pattern matching" dalam konteks switch statement?
    Bagaimana Anda mengatasi situasi di mana tidak ada kasus yang cocok dalam pernyataan switch?
4. Opsional (Optional):
    Apa itu opsional (optional) dalam Swift, dan mengapa digunakan?
    Bagaimana Anda mendeklarasikan dan menggunakan variabel opsional?
    Apa perbedaan antara "unwrapping" opsional secara aman dengan "force unwrapping"?
    Bagaimana Anda menangani nilai-nilai nil dalam opsional?
5. Operasi String:
    Bagaimana Anda menggabungkan (concatenate) dua string dalam Swift?
    Bagaimana Anda menghitung panjang (count) sebuah string?
    Apa itu interpolasi string, dan bagaimana cara penggunaannya?
6. Error Handling (Penanganan Error):
    Apa itu "Error" dalam Swift, dan mengapa Anda memerlukan penanganan error?
    Bagaimana Anda menggunakan pernyataan do, try, dan catch untuk menangani error?
    Apa perbedaan antara try?, try!, dan try dalam Swift?
</pre>


## Hari 2: Dasar-dasar Pemrograman Swift (2)

### Tujuan

1. Siswa memahami dan mampu menggunakan struktur data yang ada pada Swift.
2. Siswa memahami dan mampu menggunakan Looping
3. Siswa memahami dan mampu menggunakan Penggunaan Operator Dan Conditional Di Swift.
4. Siswa memahami cara menangani kesalahan atau *exception*.

### Pembahasan

1. Struktur data di Swift
2. Penggunaan Looping
3. Penggunaan Operator Dan Conditional Swift
4. Penanganan *errors dan exceptions*.
5. Penanganan Nullability Di Swift

### Pembelajaran

```
Materi dan Penjelasan
```

1. [Swift data structures](https://www.swift.org/blog/swift-collections/)
2. [Penggunaan Looping](https://www.programiz.com/swift-programming/for-in-loop)
3. [Penggunaan Operator](https://www.programiz.com/swift-programming/operators).
4. [Errors and Exceptions](https://www.programiz.com/swift-programming/error-handling).
5. [Nullability Swift](https://www.hackingwithswift.com/read/0/12/optionals)

```
Latihan
```

Kerjakan materi-materi di point 1,2, 3,4 dan  5 menggunakan playground 

```
Kasus
```

Buatlah 5 function sesuai materi di atas . Buatlah 5 function tersebut menjadi module dan tunjukkan juga cara menggunakan module tersebut.

## Hari 3: Class dan Structure di Swift

### Tujuan

1. Siswa memahami pola pikir obyek.
2. Siswa memahami dan mampu membuat *source code* menggunakan paradigma pemrograman berorientasi obyek.
3. Siswa mengenal *standard library* dan bisa menggunakan pustaka-pustaka tersebut dalam *source code*.
4. Siswa mampu membedakan penggunaan Class dan Structure

### Pembahasan

1. Pola Pikir Obyek
2. Pemrograman Berorientasi Obyek di Swift
3. Pembahasan Class Dan Struct
4. Penggunaan extension pada Class
5. *Swift standard library*

### Pembelajaran

```
Materi dan Penjelasan
```

1. [Ringkasan OOP di WIkipedia](https://en.wikipedia.org/wiki/Object-oriented_programming)
2. [Class](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/)


```
Latihan
```

1. Buatlah sebuah Class Dan Struct yang berisi beberapa Methode kemudian implementasikan code tersebut beserta penggunaanya


```
Kasus
```
  
2. Berkreasilah membuat program kecil yang memanfaatkan *standard library* dari Swift.

## Hari 4: Dasar Dasar Layout Component Di Xcode

### Tujuan

1. Siswa memahami Dasar Layout Di Xcode
2. Siswa memahami Dasar Component Xcode Menggunakan UIKit.
3. Siswa memahami Stuktur Project Menggunakan Arsitektur MVVM
4. Siswa memahami LifeCycle di XCode


### Pembahasan

1. Dasar Layout Swift
2. Dasar Component di Swift
3. Dasar Structure MVVM
4. Inisialisasi Project Di Xcode

### Pembelajaran

```
Materi dan Penjelasan
```

1. [Dasar Layout](https://www.hackingwithswift.com/100)
2. [Dasar Component UIKIT](https://developer-apple-com.translate.goog/documentation/uikit?_x_tr_sl=en&_x_tr_tl=id&_x_tr_hl=id&_x_tr_pto=tc&_x_tr_hist=true)
3. [Dasar MVVM](https://www.slideshare.net/sujithkumar9212301/advance-oop-concepts-in-Swift).

```
Latihan
```

1. Kerjakan nomor 1,2 di atas menggunakan Xcode.
2. Buatlah Rangkuman tentang Arsitektur MVVM dan di tulis Dalam readme.md


## Hari 5: Dasar Dasar Layout Component Di Xcode

### Tujuan

1. Siswa memahami Navigation
2. Siswa memahami Penggunaan TableView Dan CollectionView
3. Siswa memahami Penggunaan Scrollview
4. Siswa mampu menggunakan Inputan Camera.

### Pembahasan

1. Materi Tentang Navigation , TableView, CollectionView, dan ScrollView di XCode

### Pembelajaran

```
Materi dan Penjelasan
```

1. [Navigation Swift](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
2. [TableView](https://medium.com/@rizal_hilman/swift-uitableview-simple-food-categories-app-e1b18d505984).
3. [Collection View](https://www.kodeco.com/18895088-uicollectionview-tutorial-getting-started)
3. [ScrollView](https://medium.nextlevelswift.com/using-uiscrollview-in-swift5-with-autolayout-b0e463d3e5fb).
4. [Input Camera](https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift).

```
Latihan
```

1. Kerjakan `Materi dan Penjelasan` di atas.


```
Kasus
```

1. Buat 2 buah file UIViewController, Implementasikan TableView dan CollectionView menggunakan data dummy dari struct. 
2. Buatlah Halaman yang bisa navigasi ke halaman lain


