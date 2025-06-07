abstract class ImageEvent {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageFetch extends ImageEvent {}

class ImageFetchByCategory extends ImageEvent {
  final String category;

  ImageFetchByCategory(this.category);

  @override
  List<Object> get props => [category];
}
