import 'dart:io';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/view_model/home_view_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _songNameController = TextEditingController();
  final _artistController = TextEditingController();
  Color _selectedColor = Pallete.cardColor; // Default color
  File? selectedAudio;
  File? selectedImage;

  final _formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    } else {
      print('No audio file selected');
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    } else {
      print('No Image file selected');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _songNameController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((val) => val?.isLoading == true),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedImage: selectedImage!,
                      songName: _songNameController.text,
                      artist: _artistController.text,
                      selectedColor: _selectedColor,
                    );
              } else {
                showSnackbar(context, "Missing Fields");
              }
            },
          ),
        ],
      ),

      body:
          isLoading
              ? Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: selectImage,
                          child:
                              selectedImage != null
                                  ? SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                  : DottedBorder(
                                    options: RectDottedBorderOptions(
                                      color: Pallete.borderColor,
                                      dashPattern: [10, 4],
                                      strokeWidth: 2,
                                      padding: EdgeInsets.all(16),
                                    ),
                                    child: SizedBox(
                                      height: 150,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.folder_open, size: 50),
                                          SizedBox(height: 10),
                                          Text(
                                            'Select thumbnail for your song',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(height: 40),
                        selectedAudio != null
                            ? AudioWave(path: selectedAudio!.path)
                            : CustomField(
                              hintText:
                                  selectedAudio != null
                                      ? selectedAudio.toString().split('/').last
                                      : 'Pick a song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                        SizedBox(height: 20),
                        CustomField(
                          hintText: 'Artist',
                          controller: _artistController,
                        ),
                        SizedBox(height: 20),
                        CustomField(
                          hintText: 'Song Name',
                          controller: _songNameController,
                        ),
                        SizedBox(height: 20),
                        ColorPicker(
                          heading: Text("Select a color for your song"),
                          pickersEnabled: {
                            ColorPickerType.primary: true,
                            ColorPickerType.accent: true,
                            ColorPickerType.wheel: true,
                          },
                          color: _selectedColor,
                          onColorChanged: (Color color) {
                            // Handle color change
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
