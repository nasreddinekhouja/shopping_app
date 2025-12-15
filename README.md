#  Shopping App

A simple Flutter shopping app where you can browse products and add them to your cart.

## Features

- User login
- View products (from Fake Store API)
- Add to cart
- Remove from cart
- Checkout

## MVVM Architecture

This app uses **MVVM** pattern with 3 parts:

**Model** - Your data (Product class)

**View** - Your screens (ProductScreen, CartScreen)

**ViewModel** - Manages data and logic (ShoppingCart Provider)

### How it works:
```
User clicks button → View → ViewModel updates data → View shows changes
```

## Project Structure

```
lib/
├── models/          # Data classes
├── viewmodels/      # State management
└── views/           # UI screens
```

## Run the App

```bash
flutter pub get
flutter run
```

## Technologies

- Flutter
- Provider (state management)
- Fake Store API (products & authentication)