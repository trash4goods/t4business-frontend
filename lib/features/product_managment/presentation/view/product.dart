import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/sidebar_navigation.dart';
import '../controllers/interface/product.dart';
import '../presenters/interface/product.dart';
import '../widgets/create_product_fab.dart';
import '../widgets/products_responsive_layout.dart';

class ProductsPage
    extends
        CustomGetView<ProductsControllerInterface, ProductsPresenterInterface> {
  const ProductsPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1200;
        if (hasScaffoldAncestor) {
          return SafeArea(
            child: Stack(
              children: [
                ShadDecorator(
                  decoration: ShadDecoration(color: AppColors.surfaceElevated),
                  child: ProductsResponsiveLayout(presenter: presenter),
                ),
                Obx(() {
                  // Hide FAB when in create/edit mode
                  final showFAB = !presenter.isCreating.value && presenter.editingProduct.value == null;
                  if (!showFAB) return const SizedBox.shrink();
                  
                  return Positioned(
                    bottom: 16,
                    right: 16,
                    child: CreateProductFAB(
                      constraints: constraints,
                      onPressed: () => presenter.startCreate(),
                    ),
                  );
                }),
              ],
            ),
          );
        } else {
          return Scaffold(
            key: presenter.scaffoldKey,
            backgroundColor: const Color(0xFFFAFAFA),
            appBar:
                (isMobile || isTablet)
                    ? AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed:
                            () =>
                                presenter.scaffoldKey.currentState
                                    ?.openDrawer(),
                      ),
                    )
                    : null,
            drawer:
                (isMobile || isTablet)
                    ? Drawer(
                      child: SidebarNavigation(
                        currentRoute: presenter.currentRoute.value,
                        isCollapsed: false,
                        onToggle: presenter.onToggle,
                        onNavigate: (route) => presenter.onNavigate(route),
                        onLogout: presenter.onLogout,
                      ),
                    )
                    : null,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ShadDecorator(
                    decoration: ShadDecoration(
                      color: AppColors.surfaceElevated,
                    ),
                    child: ProductsResponsiveLayout(presenter: presenter),
                  );
                },
              ),
            ),
            floatingActionButton: Obx(() {
              // Hide FAB when in create/edit mode
              final showFAB = !presenter.isCreating.value && presenter.editingProduct.value == null;
              if (!showFAB) return const SizedBox.shrink();
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  return CreateProductFAB(
                    constraints: constraints,
                    onPressed: () => presenter.startCreate(),
                  );
                },
              );
            }),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        }
      },
    );
  }
}
