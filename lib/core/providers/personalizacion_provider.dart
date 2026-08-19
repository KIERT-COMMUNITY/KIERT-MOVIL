import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiert_movil/core/models/personalizacion.dart';
import 'package:kiert_movil/core/services/personalizacion_service.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';

final personalizacionServiceProvider = Provider<PersonalizacionService>((ref) {
  return PersonalizacionService();
});

final personalizacionStateProvider =
    StateNotifierProvider<PersonalizacionNotifier, PersonalizacionState>((ref) {
  return PersonalizacionNotifier(ref);
});

class PersonalizacionState {
  final Personalizacion? personalizacion;
  final List<Marco> marcos;
  final List<Fondo> fondos;
  final bool isLoading;

  PersonalizacionState({
    this.personalizacion,
    this.marcos = const [],
    this.fondos = const [],
    this.isLoading = false,
  });

  String get temaId => personalizacion?.temaId ?? 'default';
  String get marcoId => personalizacion?.marcoId ?? 'none';
  String get fondoId => personalizacion?.fondoId ?? 'default';

  PersonalizacionState copyWith({
    Personalizacion? personalizacion,
    List<Marco>? marcos,
    List<Fondo>? fondos,
    bool? isLoading,
  }) {
    return PersonalizacionState(
      personalizacion: personalizacion ?? this.personalizacion,
      marcos: marcos ?? this.marcos,
      fondos: fondos ?? this.fondos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PersonalizacionNotifier extends StateNotifier<PersonalizacionState> {
  final Ref ref;

  PersonalizacionNotifier(this.ref) : super(PersonalizacionState()) {
    _cargarDatos();
  }

  void _cargarDatos() {
    final authState = ref.read(authStateProvider);
    if (authState.user != null) {
      cargarTodos();
    }
  }

  Future<void> cargarTodos() async {
    state = state.copyWith(isLoading: true);
    await cargarPersonalizacion();
    await cargarMarcos();
    await cargarFondos();
    state = state.copyWith(isLoading: false);
  }

  Future<void> cargarPersonalizacion() async {
    final service = ref.read(personalizacionServiceProvider);
    final data = await service.obtenerPersonalizacion();
    if (data != null) {
      state = state.copyWith(personalizacion: data);
    }
  }

  Future<void> cargarMarcos() async {
    final service = ref.read(personalizacionServiceProvider);
    final data = await service.obtenerMarcos();
    state = state.copyWith(marcos: data);
  }

  Future<void> cargarFondos() async {
    final service = ref.read(personalizacionServiceProvider);
    final data = await service.obtenerFondos();
    state = state.copyWith(fondos: data);
  }

  Future<bool> guardarPersonalizacion({
    required String temaId,
    required String marcoId,
    required String fondoId,
  }) async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(personalizacionServiceProvider);
    final data = await service.guardarPersonalizacion(
      temaId: temaId,
      marcoId: marcoId,
      fondoId: fondoId,
    );
    if (data != null) {
      state = state.copyWith(personalizacion: data, isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  void recargar() {
    cargarTodos();
  }
}
