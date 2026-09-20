/// The real operational lifecycle a partner order moves through — every
/// Partner workflow screen (#53-57) is a real step in this same sequence,
/// not decorative labels.
enum PartnerOrderStage {
  received,
  inspecting,
  processing,
  qualityControl,
  packaging,
  readyForHandoff,
  handedOff,
}

extension PartnerOrderStageX on PartnerOrderStage {
  String get label => switch (this) {
    PartnerOrderStage.received => 'Received',
    PartnerOrderStage.inspecting => 'Inspection',
    PartnerOrderStage.processing => 'Processing',
    PartnerOrderStage.qualityControl => 'Quality Control',
    PartnerOrderStage.packaging => 'Packaging',
    PartnerOrderStage.readyForHandoff => 'Ready for Driver',
    PartnerOrderStage.handedOff => 'Handed Off',
  };

  PartnerOrderStage? get next {
    const order = PartnerOrderStage.values;
    final i = order.indexOf(this);
    return i < order.length - 1 ? order[i + 1] : null;
  }
}

class PartnerOrderItem {
  const PartnerOrderItem({
    required this.garment,
    required this.count,
    this.note,
  });
  final String garment;
  final int count;
  final String? note;
}

class PartnerOrder {
  PartnerOrder({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.service,
    required this.items,
    required this.totalOmr,
    required this.dueLabel,
    this.stage = PartnerOrderStage.received,
    this.inspectionNotes,
  });

  final String id;
  final String customerName;
  final String customerImage;
  final String service;
  final List<PartnerOrderItem> items;
  final double totalOmr;
  final String dueLabel;
  PartnerOrderStage stage;
  String? inspectionNotes;

  int get itemCount => items.fold(0, (sum, i) => sum + i.count);
}

class PartnerServiceOffering {
  PartnerServiceOffering({
    required this.name,
    required this.priceOmr,
    this.available = true,
  });
  final String name;
  double priceOmr;
  bool available;
}
