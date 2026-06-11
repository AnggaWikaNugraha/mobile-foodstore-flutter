const _serverBase = 'https://foodstore-server-nu.vercel.app/upload/';

String normalizeImageUrl(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
  final hasExt = raw.endsWith('.png') || raw.endsWith('.jpg') ||
      raw.endsWith('.jpeg') || raw.endsWith('.webp');
  return hasExt ? '$_serverBase$raw' : '$_serverBase$raw.png';
}
