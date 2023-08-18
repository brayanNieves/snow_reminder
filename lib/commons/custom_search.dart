import 'package:flutter/material.dart';

class SnowEatsSearch extends StatelessWidget {
  final bool visible;
  final double borderRadius;
  final bool autoFocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final String hint;
  final bool showCancelButton;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onCancelTap;
  final GestureTapCallback? onSearchTap;
  final FocusNode? focusNode;
  final Widget? suffix;

  const SnowEatsSearch(
      {Key? key,
      this.visible = true,
      this.borderRadius = 0.0,
      this.autoFocus = true,
      this.controller,
      this.onChanged,
      this.autocorrect = true,
      this.enableSuggestions = true,
      this.hint = '',
      this.showCancelButton = false,
      this.onCancelTap,
      this.onSearchTap,
      this.focusNode,
      this.suffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Visibility(
              visible: visible,
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: autoFocus,
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: onChanged,
                        autocorrect: autocorrect,
                        enableSuggestions: enableSuggestions,
                        decoration: InputDecoration(
                          hintText: hint,
                          suffix: suffix,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (showCancelButton)
                      GestureDetector(
                        onTap: onCancelTap,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPlaceHolder extends StatelessWidget {
  final GestureTapCallback? onTap;

  const SearchPlaceHolder({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black12,
        ),
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8.0,),
                  Text(
                    'Buscar palabras',
                    style: TextStyle(fontSize: 17.0,color: Colors.grey),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
