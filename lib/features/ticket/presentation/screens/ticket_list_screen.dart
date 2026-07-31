import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/entities/ticket_sort_order.dart';
import '../../domain/entities/ticket_status.dart';
import '../providers/displayed_tickets_provider.dart';
import '../providers/ticket_filter_provider.dart';
import '../providers/ticket_list_provider.dart';
import '../providers/ticket_search_provider.dart';
import '../providers/ticket_sort_provider.dart';
import '../widgets/ticket_card.dart';

/// Displays searchable, filterable, and sortable ticket list.
class TicketListScreen extends ConsumerWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(displayedTicketsProvider);
    final sortOrder = ref.watch(ticketSortProvider);
    final statusFilter = ref.watch(ticketFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        actions: [
          PopupMenuButton<TicketSortOrder>(
            tooltip: 'Sort tickets',
            initialValue: sortOrder,
            onSelected: ref.read(ticketSortProvider.notifier).updateSortOrder,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TicketSortOrder.newestFirst,
                child: Text('Newest First'),
              ),
              PopupMenuItem(
                value: TicketSortOrder.oldestFirst,
                child: Text('Oldest First'),
              ),
            ],
            icon: const Icon(Icons.sort_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _TicketListControls(
            statusFilter: statusFilter,
            onSearchChanged: ref.read(ticketSearchProvider.notifier).updateQuery,
            onStatusFilterChanged:
                ref.read(ticketFilterProvider.notifier).updateFilter,
          ),
          Expanded(
            child: ticketsAsync.when(
              data: (tickets) => _TicketListBody(tickets: tickets),
              loading: () => const LoadingWidget(),
              error: (error, _) => EmptyStateWidget(
                icon: Icons.error_outline_rounded,
                title: 'Unable to load tickets',
                message: error.toString(),
                action: PrimaryButton(
                  label: 'Try Again',
                  icon: Icons.refresh_rounded,
                  onPressed: () =>
                      ref.read(ticketListProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.createTicket),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Ticket'),
      ),
    );
  }
}

class _TicketListControls extends ConsumerStatefulWidget {
  const _TicketListControls({
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
  });

  final TicketStatus? statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<TicketStatus?> onStatusFilterChanged;

  @override
  ConsumerState<_TicketListControls> createState() =>
      _TicketListControlsState();
}

class _TicketListControlsState extends ConsumerState<_TicketListControls> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: ref.read(ticketSearchProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _searchController,
            label: 'Search',
            hint: 'Search by subject',
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      widget.onSearchChanged('');
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  )
                : null,
            onChanged: (value) {
              widget.onSearchChanged(value);
              setState(() {});
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: widget.statusFilter == null,
                    onSelected: (_) => widget.onStatusFilterChanged(null),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  for (final status in TicketStatus.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(status.label),
                        selected: widget.statusFilter == status,
                        onSelected: (_) =>
                            widget.onStatusFilterChanged(status),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketListBody extends ConsumerWidget {
  const _TicketListBody({required this.tickets});

  final List<Ticket> tickets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tickets.isEmpty) {
      return const _EmptyTicketList();
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(ticketListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          88,
        ),
        itemCount: tickets.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final ticket = tickets[index];

          return TicketCard(
            ticket: ticket,
            onTap: () => context.push(RouteNames.ticketDetailsPath(ticket.id)),
          );
        },
      ),
    );
  }
}

class _EmptyTicketList extends ConsumerWidget {
  const _EmptyTicketList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTicketsAsync = ref.watch(ticketListProvider);
    final hasFilters =
        ref.watch(ticketSearchProvider).trim().isNotEmpty ||
        ref.watch(ticketFilterProvider) != null;

    final hasNoTickets = allTicketsAsync.maybeWhen(
      data: (tickets) => tickets.isEmpty,
      orElse: () => false,
    );

    if (hasNoTickets) {
      return EmptyStateWidget(
        icon: Icons.confirmation_number_outlined,
        title: 'No tickets yet',
        message: 'Create your first support ticket to get started.',
        action: PrimaryButton(
          label: 'Create Ticket',
          icon: Icons.add_rounded,
          onPressed: () => context.push(RouteNames.createTicket),
        ),
      );
    }

    if (hasFilters) {
      return EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: 'No matching tickets',
        message: 'Try adjusting your search or filter criteria.',
        action: PrimaryButton(
          label: 'Clear Filters',
          icon: Icons.filter_alt_off_outlined,
          onPressed: () {
            ref.read(ticketSearchProvider.notifier).clear();
            ref.read(ticketFilterProvider.notifier).clear();
          },
        ),
      );
    }

    return const EmptyStateWidget(
      icon: Icons.confirmation_number_outlined,
      title: 'No tickets found',
      message: 'There are no tickets to display.',
    );
  }
}
