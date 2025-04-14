import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_learn_widget/utils/api.dart';
import 'package:tradeable_learn_widget/utils/constants.dart';
import 'package:tradeable_learn_widget/utils/s3_uploader.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/educorner_v2/educorner_v2_model.dart';

class EduCornerV2Editor extends StatefulWidget {
  final EducornerV2Model? model;
  final VoidCallback onSave;

  const EduCornerV2Editor({super.key, this.model, required this.onSave});

  @override
  State<EduCornerV2Editor> createState() => _EduCornerV2EditorState();
}

class _EduCornerV2EditorState extends State<EduCornerV2Editor> {
  late final PageController controller = PageController(viewportFraction: 0.85);
  int currentPage = 0;
  late TextEditingController contentController;
  late EducornerV2Model model;

  @override
  void initState() {
    super.initState();
    model = widget.model ?? EducornerV2Model.fromJson({"items": []});
    if (model.items.isEmpty) {
      model.items.add(EduCornerV2Item(imageUrl: "", content: ""));
    }
    contentController =
        TextEditingController(text: model.items[currentPage].content);
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  void _addNewPage() {
    setState(() {
      model.items.add(EduCornerV2Item(imageUrl: "", content: ""));
      contentController.text = "";
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.animateToPage(model.items.length - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  void _deletePage() {
    if (model.items.isNotEmpty) {
      setState(() {
        model.items.removeAt(currentPage);
        currentPage =
            (currentPage == model.items.length) ? currentPage - 1 : currentPage;
        contentController.text = model.items[currentPage].content;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        await Api().getAwsKeys().then((val) async {
          File imageFile = File(result.files.single.path!);
          final uploader = S3Uploader(
            accessKey: val["credentials"]["access_key_id"],
            secretKey: val["credentials"]["secret_access_key"],
            sessionToken: val["credentials"]["session_token"],
            bucketName: bucket,
            dirName: 'white_label_tradeable/org_2/images',
            region: region,
          );
          final url = await uploader.uploadImage(imageFile: imageFile);

          setState(() {
            model.items[currentPage].imageUrl = url ?? "";
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _copyToClipboard() {
    final jsonStr = jsonEncode(model.toJson());
    Clipboard.setData(ClipboardData(text: jsonStr));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("JSON copied to clipboard!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final items = model.items;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addNewPage),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deletePage),
          IconButton(icon: const Icon(Icons.copy), onPressed: _copyToClipboard),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                _buildEditorSlider(constraints, colors, items),
                _buildTextEditor(colors, items[currentPage]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditorSlider(
      BoxConstraints constraints, dynamic colors, List<EduCornerV2Item> items) {
    return Column(
      children: [
        SizedBox(
          height: constraints.maxHeight * 0.55,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            onPageChanged: (index) => setState(() {
              currentPage = index;
              contentController.text = items[currentPage].content;
            }),
            itemBuilder: (context, index) =>
                _buildImageEditor(colors, items[index]),
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: controller,
          count: items.length,
          effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: colors.primary,
              dotColor: colors.secondary),
        ),
      ],
    );
  }

  Widget _buildImageEditor(dynamic colors, EduCornerV2Item item) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.eduCornerV2ContainerBg1,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: item.imageUrl.isNotEmpty
                  ? item.imageUrl.startsWith("http")
                      ? Image.network(item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildPlaceholderImage())
                      : Image.file(File(item.imageUrl), fit: BoxFit.cover)
                  : _buildPlaceholderImage(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.upload),
          label: const Text("Upload Image"),
          style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
        color: Colors.grey[300],
        child: const Center(
            child: Icon(Icons.image, size: 60, color: Colors.grey)));
  }

  Widget _buildTextEditor(dynamic colors, EduCornerV2Item item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colors.eduCornerV2ContainerBg1),
      child: TextField(
        controller: contentController,
        maxLines: 4,
        decoration: const InputDecoration(
            hintText: "Enter content...", border: InputBorder.none),
        onChanged: (value) => item.content = value,
      ),
    );
  }
}
