import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonImage extends StatelessWidget {
  /// resolvedImage: hasil akhir yang sudah kamu set di controller.
  final String? resolvedImage;

  /// graphqlImage: image URL asli dari GraphQL, dipakai sebagai fallback terakhir.
  final String? graphqlImage;

  /// optional hero tag (misal: 'pokemon-25') untuk hero animation
  final String? heroTag;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// Jika ingin gambar sedikit transparan, set 0.0 - 1.0 (1.0 = opaque)
  final double opacity;

  /// Jika ingin tint warna lembut di atas gambar, set warna ini.
  /// Tint akan diaplikasikan menggunakan BlendMode.modulate secara default.
  final Color? tintColor;
  final BlendMode tintBlend;

  final Widget? placeholder;
  final Widget? errorWidget;

  const PokemonImage({
    Key? key,
    required this.resolvedImage,
    this.graphqlImage,
    this.heroTag,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.opacity = 1.0,
    this.tintColor,
    this.tintBlend = BlendMode.modulate,
    this.placeholder,
    this.errorWidget,
  })  : assert(opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  bool _isAsset(String? path) => path != null && path.startsWith('assets/');

  Widget _maybeWrapHero(Widget child) {
    if (heroTag == null) return child;
    return Hero(tag: heroTag!, child: child);
  }

  Widget _wrapOpacity(Widget child) {
    if (opacity >= 0.999) return child;
    return Opacity(opacity: opacity, child: child);
  }

  Widget _buildAsset(String assetPath) {
    final img = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      // apply tint only if provided, with safe blend mode
      color: tintColor,
      colorBlendMode: tintColor != null ? tintBlend : null,
    );

    return _maybeWrapHero(_wrapOpacity(img));
  }

  Widget _buildNetwork(String url) {
    return _maybeWrapHero(
      CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (c, u) => placeholder ?? const SizedBox.shrink(),
        errorWidget: (c, u, e) => errorWidget ?? const Icon(Icons.broken_image),
        imageBuilder: (context, imageProvider) {
          // build Image from provider, apply tint if requested, then opacity
          final img = Image(
            image: imageProvider,
            width: width,
            height: height,
            fit: fit,
            color: tintColor,
            colorBlendMode: tintColor != null ? tintBlend : null,
          );
          return _wrapOpacity(img);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = (resolvedImage ?? '').trim();
    final fallback = (graphqlImage ?? '').trim();

    if (_isAsset(resolved)) {
      return _buildAsset(resolved);
    }

    if (resolved.isNotEmpty) {
      return _buildNetwork(resolved);
    }

    if (fallback.isNotEmpty) {
      return _buildNetwork(fallback);
    }

    // nothing available -> placeholder/error
    final p = placeholder ??
        Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
        );
    return _wrapOpacity(_maybeWrapHero(p));
  }
}
