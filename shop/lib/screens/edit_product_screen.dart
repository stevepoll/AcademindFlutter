import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _product = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _isLoading = false;

  void _setIsLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      final url = _imageUrlController.text;
      if ((!(url.startsWith('http') || url.startsWith('https'))) ||
          (!(url.endsWith('jpg') || url.endsWith('jpeg') || url.endsWith('png')))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      _setIsLoading(true);
      if (_product.id == null) {
        // Add new product
        try {
          await Provider.of<Products>(context, listen: false).addProduct(_product);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurred'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Dismiss'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        }
        // finally {
        //   _setIsLoading(false);
        //   Navigator.of(context).pop();
        // }
      } else {
        // Edit existing product
        await Provider.of<Products>(context, listen: false).updateProduct(_product.id, _product);
      }
      _setIsLoading(false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      _product = Provider.of<Products>(context, listen: false).findById(productId);
      _imageUrlController.text = _product.imageUrl;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // ***** Title
                    TextFormField(
                      initialValue: _product.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (v) {
                        _product = Product(
                          title: v,
                          id: _product.id,
                          isFavorite: _product.isFavorite,
                          imageUrl: _product.imageUrl,
                          description: _product.description,
                          price: _product.price,
                        );
                      },
                      validator: (v) => v.isEmpty ? 'Please enter a title' : null,
                    ),
                    // ***** Price
                    TextFormField(
                      initialValue: _product.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (v) {
                        _product = Product(
                          title: _product.title,
                          id: _product.id,
                          isFavorite: _product.isFavorite,
                          imageUrl: _product.imageUrl,
                          description: _product.description,
                          price: double.parse(v),
                        );
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(v) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(v) <= 0) {
                          return 'Please enter a number greater than zero';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // ***** Description
                    TextFormField(
                      initialValue: _product.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (v) {
                        _product = Product(
                          title: _product.title,
                          id: _product.id,
                          isFavorite: _product.isFavorite,
                          imageUrl: _product.imageUrl,
                          description: v,
                          price: _product.price,
                        );
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (v.length < 10) {
                          return 'Description should be at least 10 characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // ***** Image URL
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (v) {
                              if (v.isEmpty) {
                                return 'Please enter an image URL';
                              }
                              if (!(v.startsWith('http') || v.startsWith('https'))) {
                                return 'Please enter a valid URL';
                              }
                              if (!(v.endsWith('jpg') || v.endsWith('jpeg') || v.endsWith('png'))) {
                                return 'Please enter a valid image URL';
                              }
                              return null;
                            },
                            onSaved: (v) {
                              _product = Product(
                                title: _product.title,
                                id: _product.id,
                                isFavorite: _product.isFavorite,
                                imageUrl: v,
                                description: _product.description,
                                price: _product.price,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
