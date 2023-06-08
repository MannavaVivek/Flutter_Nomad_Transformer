// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogPostAdapter extends TypeAdapter<BlogPost> {
  @override
  final int typeId = 0;

  @override
  BlogPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogPost(
      postId: fields[0] as String,
      title: fields[1] as String,
      summary: fields[2] as String,
      caption: fields[3] as String,
      imageUrl: fields[4] as String,
      imageAttribution: fields[5] as String,
      content: fields[6] as String,
      country: fields[7] as String,
      city: fields[8] as String,
      isLiked: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BlogPost obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.caption)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.imageAttribution)
      ..writeByte(6)
      ..write(obj.content)
      ..writeByte(7)
      ..write(obj.country)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.isLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
