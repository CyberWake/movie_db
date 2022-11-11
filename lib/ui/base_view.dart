import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/services/service_locator.dart';

class BaseView<T extends Cubit> extends StatefulWidget {
  const BaseView({super.key,
    required this.builder,
    this.onModelReady,
    this.onChangeAppLifeCycle,
    this.keepAlive = false,
  });

  final Function(T, TickerProviderStateMixin vsync)? onModelReady;
  final Function(T)? onChangeAppLifeCycle;
  final Widget Function(BuildContext, T) builder;
  final bool keepAlive;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Cubit> extends State<BaseView<T>>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  T model = serviceLocator<T>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    widget.onModelReady?.call(model, this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      widget.onChangeAppLifeCycle?.call(model);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepositoryProvider(
      create: (context) => model,
      child: BlocBuilder<T, dynamic>(
        builder: (context, state) {
          return widget.builder(context, model);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
