import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool scrollableAppBar;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBackButton = false,
    this.scrollableAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollableAppBar) {
      return _ScrollableScaffold(
        title: title,
        body: body,
        actions: actions,
        showBackButton: showBackButton,
      );
    }

    return _StaticScaffold(
      title: title,
      body: body,
      actions: actions,
      showBackButton: showBackButton,
    );
  }
}

class _ScrollableScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;

  const _ScrollableScaffold({
    required this.title,
    required this.body,
    this.actions,
    required this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E2C),
              Color(0xFF121212),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: actions,
            ),
            SliverToBoxAdapter(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;

  const _StaticScaffold({
    required this.title,
    required this.body,
    this.actions,
    required this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: actions,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E2C),
              Color(0xFF121212),
            ],
          ),
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}