import 'package:flutter/material.dart';

// Modèle de données
class Product {
  final String name;
  final double price;
  final String image;
  final bool isNew;
  final double rating;

  const Product(
    this.name,
    this.price,
    this.image, {
    this.isNew = false,
    this.rating = 0.0,
  });
}

class ProductList extends StatelessWidget {
  ProductList({super.key});

  final List<Product> products = const [
    Product('iPhone 15', 999, 'iphone-15.jpg', isNew: true, rating: 4.5),
    Product('Samsung Galaxy', 799, 'samsung.jpg', isNew: false, rating: 4.2),
    Product('Google Pixel', 699, 'google.jpg', isNew: true, rating: 4.7),
  ];

  // Service de panier utilisé pour ajouter des articles
  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Produits'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          ValueListenableBuilder<double>(
            valueListenable: cartService._totalPrice,
            builder: (context, total, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: colorScheme.onSurface,
                    ),
                    onPressed: () {
                      // Action pour afficher le panier
                      _showCartModal(context);
                    },
                  ),

                  if (cartService.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          cartService.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardExpandable(
            product: product,
            cartService: cartService,
            colorScheme: colorScheme,
          );
        },
      ),
    );
  }

  void _showCartModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Récapitulatif Panier',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Articles: ${cartService.itemCount}'),
              Text('Total: ${cartService.totalPrice.toStringAsFixed(2)}€'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductCardExpandable extends StatefulWidget {
  final Product product;
  final CartService cartService;
  final ColorScheme colorScheme;

  const ProductCardExpandable({
    super.key,
    required this.product,
    required this.cartService,
    required this.colorScheme,
  });

  @override
  State<ProductCardExpandable> createState() => _ProductCardExpandableState();
}

class _ProductCardExpandableState extends State<ProductCardExpandable> {
  bool _isExpanded = false;

  String _getLocalImagePath(String imageName) {
    return 'images/$imageName';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // PARTIE COMPACTE (toujours visible)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Image avec badge
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(
                              _getLocalImagePath(widget.product.image),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (widget.product.isNew)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Informations produit compactes
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(widget.product.rating.toString()),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.product.price}€',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: widget.colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bouton action rapide + indicateur
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.cartService.addItem(widget.product, 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.product.name} ajouté au panier',
                              ),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Voir',
                                onPressed: () {
                                  // Action pour voir le panier
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Récapitulatif Panier',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Articles: ${widget.cartService.itemCount}',
                                            ),
                                            Text(
                                              'Total: ${widget.cartService.totalPrice.toStringAsFixed(2)}€',
                                            ),
                                            const SizedBox(height: 16),
                                            const SizedBox(height: 16),
                                            FilledButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Fermer'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: widget.colorScheme.primary,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: widget.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // PARTIE DÉTAILLÉE (conditionnelle)
          if (_isExpanded) ...[
            const Divider(height: 1),
            _buildProductDetails(),
          ],
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Description',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Découvrez le ${widget.product.name}, un produit haute performance '
            'conçu pour répondre à tous vos besoins. Design élégant et '
            'fonctionnalités avancées pour une expérience exceptionnelle.',
            style: TextStyle(
              color: widget.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Spécifications
          Text(
            'Spécifications',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSpecificationItem('Écran', '6.1 pouces Super Retina XDR'),
          _buildSpecificationItem('Processeur', 'A16 Bionic'),
          _buildSpecificationItem('Mémoire', '128 GB'),
          _buildSpecificationItem('Batterie', 'Jusqu\'à 20h de vidéo'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSpecificationItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: widget.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];
  final ValueNotifier<double> _totalPrice = ValueNotifier<double>(0.0);

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get totalPrice => _totalPrice.value;

  void addItem(Product product, int quantity) {
    _items.add(CartItem(product: product, quantity: quantity));
    _updateTotalPrice();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _updateTotalPrice();
    notifyListeners();
  }

  // NOUVELLE méthode pour mettre à jour le prix total
  void _updateTotalPrice() {
    _totalPrice.value = _items.fold(0, (sum, item) => sum + item.total);
  }

  // NOUVELLE méthode pour mettre à jour la quantité d'un item
  void updateItemQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      final oldItem = _items[index];
      _items[index] = CartItem(product: oldItem.product, quantity: newQuantity);
    }
    _updateTotalPrice();
    notifyListeners();
  }

  // NOUVELLE méthode pour supprimer un item
  void removeItem(int index) {
    _items.removeAt(index);
    _updateTotalPrice();
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;
}
