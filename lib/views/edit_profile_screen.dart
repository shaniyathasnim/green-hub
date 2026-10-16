import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/customer_model.dart';
import '../providers/customer_provider.dart';
import '../services/cloudinary_service.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs.dart';
import 'image_edit_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // =========================================================
  // CONTROLLERS
  // =========================================================

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _contactController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  // =========================================================
  // FIRESTORE
  // =========================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================================================
  // IMAGE PICKER
  // =========================================================

  final ImagePicker _imagePicker = ImagePicker();

  // =========================================================
  // STATE
  // =========================================================

  Uint8List? _selectedImageBytes;

  XFile? _selectedImage;

  String? _profileImageUrl;

  bool _isLoading = true;

  bool _isUpdating = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  // =========================================================
  // LOAD PROFILE
  // =========================================================

  Future<void> _loadProfile() async {
    try {
      final CustomerModel? customer = await SharedPrefs.getUser();

      if (customer == null || customer.uid == null || customer.uid!.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        _showMessage('Customer information not found');

        return;
      }

      debugPrint('Loading customer: ${customer.uid}');

      final DocumentSnapshot<Map<String, dynamic>> document = await _firestore
          .collection('customers')
          .doc(customer.uid!)
          .get();

      if (!document.exists) {
        throw Exception('Customer document not found');
      }

      final Map<String, dynamic> data = document.data() ?? {};

      if (!mounted) return;

      setState(() {
        _nameController.text = data['name']?.toString() ?? '';

        _contactController.text = data['phoneNumber']?.toString() ?? '';

        _addressController.text = data['address']?.toString() ?? '';

        _profileImageUrl = data['profileImageUrl']?.toString();
      });

      debugPrint('Profile image URL: $_profileImageUrl');
    } catch (e, stackTrace) {
      debugPrint('LOAD PROFILE ERROR: $e');

      debugPrint('STACK TRACE: $stackTrace');

      if (mounted) {
        _showMessage('Failed to load profile');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // PICK IMAGE FROM GALLERY
  // =========================================================

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        return;
      }

      final Uint8List bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });

      debugPrint('Gallery image selected: ${image.name}');
    } catch (e, stackTrace) {
      debugPrint('GALLERY IMAGE ERROR: $e');

      debugPrint('$stackTrace');

      if (mounted) {
        _showMessage('Unable to select image');
      }
    }
  }

  // =========================================================
  // PICK IMAGE FROM CAMERA
  // =========================================================

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) {
        return;
      }

      final Uint8List bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });

      debugPrint('Camera image selected: ${image.name}');
    } catch (e, stackTrace) {
      debugPrint('CAMERA IMAGE ERROR: $e');

      debugPrint('$stackTrace');

      if (mounted) {
        _showMessage('Unable to capture image');
      }
    }
  }

  // =========================================================
  // REMOVE IMAGE
  // =========================================================

  void _removeImage() {
    if (!mounted) return;

    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
      _profileImageUrl = null;
    });

    _showMessage('Profile image removed');
  }

  // =========================================================
  // IMAGE PICKER BOTTOM SHEET
  // =========================================================

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ImagePickerBottomSheet(
          onGalleryTap: () {
            Navigator.pop(context);

            _pickFromGallery();
          },
          onCameraTap: () {
            Navigator.pop(context);

            _pickFromCamera();
          },
          onRemoveTap: () {
            Navigator.pop(context);

            _removeImage();
          },
        );
      },
    );
  }

  // =========================================================
  // UPDATE PROFILE
  // =========================================================
  Future<void> _updateProfile() async {
    // Prevent multiple update button clicks
    if (_isUpdating) return;
    //-----validate contact number-----
    final String? contactError = _validateContactNumber(_contactController.text);
    if (contactError != null) {
      _showMessage(contactError);
      return;
    }
    //----------------------------------


    // Start loading
    setState(() {
      _isUpdating = true;
    });

    try {
      // =======================================================
      // GET CUSTOMER PROVIDER
      // =======================================================

      final CustomerProvider customerProvider =
      Provider.of<CustomerProvider>(
        context,
        listen: false,
      );

      // =======================================================
      // CHECK CUSTOMER
      // =======================================================

      if (customerProvider.customer == null) {
        throw Exception('Customer is not logged in');
      }

      // =======================================================
      // GET CURRENT EMAIL
      // =======================================================

      final String currentEmail =
          customerProvider.customer!.email ?? '';

      // =======================================================
      // UPDATE PROFILE IMAGE
      // =======================================================

      if (_selectedImage != null) {
        debugPrint(
          '========================================',
        );

        debugPrint(
          'Uploading new profile image...',
        );

        debugPrint(
          'Image name: ${_selectedImage!.name}',
        );

        await customerProvider.updateProfilePhoto(
          _selectedImage!,
        );

        debugPrint(
          'Profile image uploaded successfully',
        );

        debugPrint(
          '========================================',
        );
      }

      // =======================================================
      // UPDATE NAME + EMAIL + ADDRESS
      // =======================================================

      debugPrint(
        'Updating customer information...',
      );

      await customerProvider.updateCustomerProfile(
        name: _nameController.text.trim(),
        email: currentEmail,
        address: _addressController.text.trim(),
        phoneNumber: _contactController.text.trim(),
      );

      debugPrint(
        'Customer information updated successfully',
      );

      // =======================================================
      // CHECK WIDGET
      // =======================================================

      if (!mounted) return;

      // =======================================================
      // SUCCESS MESSAGE
      // =======================================================

      _showMessage(
        'Profile updated successfully',
      );

      // =======================================================
      // RETURN TO PROFILE SCREEN
      // =======================================================

      Navigator.pop(
        context,
        true,
      );
    } catch (e, stackTrace) {
      // =======================================================
      // ERROR
      // =======================================================

      debugPrint(
        '========================================',
      );

      debugPrint(
        'UPDATE PROFILE ERROR',
      );

      debugPrint(
        '$e',
      );

      debugPrint(
        'STACK TRACE',
      );

      debugPrint(
        '$stackTrace',
      );

      debugPrint(
        '========================================',
      );

      if (!mounted) return;

      _showMessage(
        'Failed to update profile',
      );
    } finally {
      // =======================================================
      // STOP LOADING
      // =======================================================

      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }


  // =========================================================
  // SHOW MESSAGE
  // =========================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _nameController.dispose();

    _contactController.dispose();

    _addressController.dispose();

    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: CardGreen))
            : Column(
                children: [
                  _buildAppBar(),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: _buildAvatar()),

                          const SizedBox(height: 28),

                          // NAME
                          _buildLabel('Name'),

                          const SizedBox(height: 8),

                          _buildField(
                            controller: _nameController,
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 18),

                          // CONTACT

                          _buildLabel('Contact Number'),


                          const SizedBox(height: 8),

                          _buildField(
                            controller: _contactController,
                            icon: Icons.call_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],

                          ),

                          const SizedBox(height: 18),

                          // ADDRESS
                          _buildLabel('Home Address'),

                          const SizedBox(height: 8),

                          _buildField(
                            controller: _addressController,
                            icon: Icons.location_on_outlined,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  _buildUpdateButton(),
                ],
              ),
      ),
    );
  }

  // =========================================================
  // APP BAR
  // =========================================================

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back, color: Black, size: 22),
          ),

          const SizedBox(width: 4),

          const Text(
            'Edit Profile',
            style: TextStyle(
              color: Black,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // AVATAR
  // =========================================================

  Widget _buildAvatar() {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: White,
            ),
            child: ClipOval(child: _buildProfileImage()),
          ),

          Positioned(
            right: 0,
            bottom: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: _showImagePicker,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CardGreen,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PROFILE IMAGE
  // =========================================================

  Widget _buildProfileImage() {
    // -------------------------------------------------------
    // SELECTED IMAGE
    // -------------------------------------------------------

    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        width: 92,
        height: 92,
        fit: BoxFit.cover,
      );
    }

    // -------------------------------------------------------
    // CLOUDINARY IMAGE
    // -------------------------------------------------------

    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return Image.network(
        _profileImageUrl!,
        width: 92,
        height: 92,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _defaultProfileImage();
        },
      );
    }

    // -------------------------------------------------------
    // DEFAULT IMAGE
    // -------------------------------------------------------

    return _defaultProfileImage();
  }

  // =========================================================
  // DEFAULT PROFILE IMAGE
  // =========================================================

  Widget _defaultProfileImage() {
    return Image.asset(
      'assets/profile_image.png',
      width: 92,
      height: 92,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 50, color: Grey);
      },
    );
  }

  // =========================================================
  // LABEL
  // =========================================================
  String? _validateContactNumber(String value) {
    final phone = value.trim();

    if (phone.isEmpty) {
      return 'Please enter your contact number';
    }

    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit mobile number';
      }
    if (phone.length != 10) {
      return 'Enter a valid 10-digit mobile number';

    }

    return null;
  }
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Black,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // =========================================================
  // TEXT FIELD
  // =========================================================

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: maxLines > 1 ? 80 : 50),
      decoration: BoxDecoration(
        color: LightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DarkGrey, width: 1),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14, top: maxLines > 1 ? 14 : 0),
            child: Icon(icon, size: 19, color: CardGreen),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLines: maxLines,
              style: const TextStyle(
                color: Grey,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(width: 14),
        ],
      ),
    );
  }

  // =========================================================
  // UPDATE BUTTON
  // =========================================================

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _isUpdating ? null : _updateProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: CardGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Grey,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isUpdating
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
