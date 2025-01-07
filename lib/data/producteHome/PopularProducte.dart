class Popularproducte {
  final String img;
  final String type;
  final String title;
  final double price;

  Popularproducte({required this.img, required this.type, required this.title, required this.price});
}

List<Popularproducte> listOfproducteHome=[
  Popularproducte(img: 'assets/images/producte/c1.png', type: 'Nike', title: 'red Nike sport chose', price: 720.0),
  Popularproducte(img: 'assets/images/producte/p2.png', type: 'Zara', title: 'T-shirt for all ages', price: 320.0),
  Popularproducte(img: 'assets/images/producte/p1.png', type: 'Adidas', title: 'we make this just for you', price: 500.0),
  Popularproducte(img: 'assets/images/producte/p1.png', type: 'Gucci', title: 'this is just for me and you', price: 10.0),
];