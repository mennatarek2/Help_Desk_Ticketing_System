// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketHistoryModelAdapter extends TypeAdapter<TicketHistoryModel> {
  @override
  final int typeId = 1;

  @override
  TicketHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketHistoryModel(
      id: fields[0] as String,
      ticketId: fields[1] as String,
      message: fields[2] as String,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TicketHistoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ticketId)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
