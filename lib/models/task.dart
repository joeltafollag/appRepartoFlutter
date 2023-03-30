class Task {
  final int id;
  final String taskName;
  final String description;
  final DateTime? inicio;
  final DateTime? fin;
  final int estatus;

  Task(
    this.id,
    this.taskName,
    this.description,
    this.inicio,
    this.fin,
    this.estatus,
  );
}

List<Task> listTask = [
  Task(
    1,
    'Olahraga',
    'Senam 30 menit',
    DateTime(2022, 9, 26, 7, 30),
    DateTime(2022, 9, 26, 7, 30),
    0,
  ),
  Task(
    2,
    'Meeting Client',
    'Janjian di Kopi Kenangan',
    DateTime(2022, 9, 26, 10, 00),
    DateTime(2022, 9, 26, 7, 30),
    0,
  ),
  Task(
    3,
    'Beli Bakso',
    'Bakso pak granat',
    DateTime(2022, 9, 26, 12, 30),
    DateTime(2022, 9, 26, 7, 30),
    0,
  ),
  Task(
    4,
    'Beli Bensin',
    'Isi Pertamax 500rb',
    DateTime(2022, 9, 26, 15, 30),
    DateTime(2022, 9, 26, 7, 30),
    0,
  ),
  Task(
    5,
    'Ambil Uang',
    'Mampir di atm indomaret',
    DateTime(2022, 9, 26, 17),
    DateTime(2022, 9, 26, 7, 30),
    0,
  ),
  Task(
    6,
    'Ketemu temen',
    'Ambil Motor yg dipinjem',
    DateTime(2022, 9, 26, 19),
    DateTime(2022, 9, 26, 7, 30),
    0,
  ),
  Task(
    7,
    'Ketemu temen',
    'Ambil Motor yg dipinjem',
    DateTime(2022, 9, 26, 19),
    null,
    2,
  ),
  Task(
    8,
    'Ketemu temen',
    'Ambil Motor yg dipinjem',
    null,
    null,
    1,
  ),
  Task(
    9,
    'Ketemu temen',
    'Ambil Motor yg dipinjem',
    null,
    null,
    1,
  ),
  Task(
    10,
    'Jemput Anak',
    'Lewat jalan adipati',
    null,
    null,
    1,
  ),
  Task(
    11,
    'Futsal',
    'di futsal jakal km 9',
    null,
    null,
    1,
  ),
];