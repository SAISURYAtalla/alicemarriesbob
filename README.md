# AliceMarriesBob

## Overview
AliceMarriesBob is a mobile application that provides users with essential financial services, including mobile recharge, bus ticket booking, money transfers, and the ability to download account statements. The app offers a seamless and intuitive experience with a secure transaction system.

## Features
1. **Mobile Recharge** - Recharge your prepaid mobile phone instantly with multiple payment options.
2. **Bus Tickets** - Book bus tickets conveniently with a user-friendly interface.
3. **Money Transfer** - Securely send money to family and friends in just a few taps.
4. **Secure Statement Download** – Easily view and download transaction statements with advanced security. Traditional PDFs rely on static passwords, making them vulnerable to brute-force attacks. Instead, we use a public-private key encryption mechanism, where the bank and user exchange digital certificates. This ensures only authorized users can decrypt and access sensitive data, enhancing security, preventing unauthorized access, and maintaining data integrity.

## Technologies Used
- **Flutter** - Cross-platform mobile app development
- **Dart** - Programming language for Flutter
- **Node.js** - Backend server development
- **Native** - Native platform integrations
- **Kotlin** - Android development
- **REST APIs** - Backend communication for financial services

## Performance Optimization & Security
In the frontend, we optimize performance and reduce unnecessary system calls by not enforcing trust token validation for non-critical actions, such as navigating through screens in the payment app. Actions like clicking on a recharge plan or selecting a contact while sharing money do not involve sensitive user data or financial transactions, so strict authentication checks are not required.

To balance security and efficiency, we implement heartbeat monitoring only when handling sensitive operations, such as processing transactions or accessing user-related information. This ensures that the user's session remains valid and authenticated only when necessary, reducing the frequency of system calls and improving app responsiveness without compromising security.

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/SAISURYAtalla/alicemarriesbob.git
   ```
2. Navigate to the project directory:
   ```sh
   cd alicemarriesbob
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the application:
   ```sh
   flutter run
   ```

## Contribution
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch (`feature-branch`).
3. Commit your changes.
4. Push to your branch and create a pull request.

## License
This project is licensed under the MIT License.

## Contact
For any queries or support, reach out to [Your Email] or visit our [GitHub Repository](https://github.com/SAISURYAtalla/alicemarriesbob).

