class Brands {
  final String logo; // URL for the Lottie animation
  final String name;
  final String manyProducts; // Change this to a String

  Brands({required this.manyProducts, required this.logo, required this.name});
}

List<Brands> ListOfBrands = [
  Brands(
    logo: "https://lottie.host/237e7e05-512d-4511-a10a-0cdc63ad58fc/fPvbIRPjz5.json",
    name: "Adidas",
    manyProducts: "122 Products"
  ),
  Brands(
    logo: "https://lottie.host/0fc553d5-1199-4f38-a18b-5f553a47fb7f/5uRILMna46.json",
    name: "Nike",
    manyProducts: "200 Products"
  ),
 
  Brands(
    logo: "https://lottie.host/784c9bd2-2535-4c32-b203-435e8d5bb6c4/Bj4UbmLSEA.json",
    name: "Apple ",
    manyProducts: "122 Products"
  ),
  Brands(
    logo: "https://lottie.host/4b551539-2011-4aab-9514-c52e794faa0c/oCMzQj6HQs.json",
    name: "Andoid",
    manyProducts: "200 Products"
  ),
 
];
