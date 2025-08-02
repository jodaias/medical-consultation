// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:medical_consultation_app/core/theme/app_theme.dart';
// import 'package:medical_consultation_app/core/utils/constants.dart';
// import 'package:medical_consultation_app/core/di/injection.dart';
// import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
// import 'package:medical_consultation_app/features/doctor/domain/stores/doctor_store.dart';
// import 'package:medical_consultation_app/features/consultation/domain/stores/consultation_store.dart';
// import 'package:medical_consultation_app/features/scheduling/domain/stores/scheduling_store.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/quick_action_card.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/upcoming_consultation_card.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/doctor_card.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/stats_card.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/notification_card.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/search_bar_widget.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/category_filter.dart';
// import 'package:medical_consultation_app/features/home/presentation/widgets/banner_slider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   final AuthStore _authStore = getIt<AuthStore>();
//   final DoctorStore _doctorStore = getIt<DoctorStore>();
//   final ConsultationStore _consultationStore = getIt<ConsultationStore>();
//   final SchedulingStore _schedulingStore = getIt<SchedulingStore>();

//   late TabController _tabController;
//   String _selectedCategory = 'Todos';
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadInitialData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadInitialData() async {
//     setState(() => _isLoading = true);

//     try {
//       await Future.wait([
//         _doctorStore.loadDoctors(),
//         _consultationStore.loadUpcomingConsultations(),
//         _schedulingStore.loadAppointments(),
//       ]);
//     } catch (e) {
//       _showErrorSnackBar('Erro ao carregar dados: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _loadInitialData,
//               child: CustomScrollView(
//                 slivers: [
//                   _buildAppBar(),
//                   _buildContent(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildAppBar() {
//     return SliverAppBar(
//       expandedHeight: 120,
//       floating: false,
//       pinned: true,
//       backgroundColor: AppTheme.primaryColor,
//       foregroundColor: Colors.white,
//       flexibleSpace: FlexibleSpaceBar(
//         title: Text(
//           'Olá, ${_authStore.userName ?? 'Usuário'}! 👋',
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 AppTheme.primaryColor,
//                 AppTheme.primaryColor.withOpacity(0.8),
//               ],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () => context.push('/notifications'),
//           icon: const Icon(Icons.notifications_outlined),
//         ),
//         IconButton(
//           onPressed: () => context.push('/profile'),
//           icon: const Icon(Icons.person_outline),
//         ),
//       ],
//     );
//   }

//   Widget _buildContent() {
//     return SliverList(
//       delegate: SliverChildListDelegate([
//         const SizedBox(height: 16),

//         // Banner Slider
//         _buildBannerSection(),

//         const SizedBox(height: 24),

//         // Quick Actions
//         _buildQuickActionsSection(),

//         const SizedBox(height: 24),

//         // Search and Categories
//         _buildSearchSection(),

//         const SizedBox(height: 24),

//         // Upcoming Consultations
//         _buildUpcomingConsultationsSection(),

//         const SizedBox(height: 24),

//         // Statistics
//         _buildStatsSection(),

//         const SizedBox(height: 24),

//         // Doctors List
//         _buildDoctorsSection(),

//         const SizedBox(height: 24),

//         // Notifications
//         _buildNotificationsSection(),

//         const SizedBox(height: 32),
//       ]),
//     );
//   }

//   Widget _buildBannerSection() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: BannerSlider(
//         banners: [
//           {
//             'title': 'Consulta Online',
//             'subtitle': 'Atendimento médico 24/7',
//             'image': 'assets/images/banner_consultation.jpg',
//             'action': () => context.push('/consultations'),
//           },
//           {
//             'title': 'Especialistas',
//             'subtitle': 'Mais de 100 médicos',
//             'image': 'assets/images/banner_doctors.jpg',
//             'action': () => context.push('/doctors'),
//           },
//           {
//             'title': 'Agendamento',
//             'subtitle': 'Marque sua consulta',
//             'image': 'assets/images/banner_scheduling.jpg',
//             'action': () => context.push('/appointments'),
//           },
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionsSection() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Ações Rápidas',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.textPrimaryColor,
//                 ),
//           ),
//           const SizedBox(height: 16),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.2,
//             children: [
//               QuickActionCard(
//                 title: 'Nova Consulta',
//                 subtitle: 'Agendar consulta',
//                 icon: Icons.medical_services,
//                 color: AppTheme.primaryColor,
//                 onTap: () => context.push('/appointments'),
//               ),
//               QuickActionCard(
//                 title: 'Encontrar Médico',
//                 subtitle: 'Buscar especialista',
//                 icon: Icons.search,
//                 color: Colors.green,
//                 onTap: () => context.push('/doctors'),
//               ),
//               QuickActionCard(
//                 title: 'Minhas Consultas',
//                 subtitle: 'Ver histórico',
//                 icon: Icons.history,
//                 color: Colors.orange,
//                 onTap: () => context.push('/consultations'),
//               ),
//               QuickActionCard(
//                 title: 'Emergência',
//                 subtitle: 'Atendimento urgente',
//                 icon: Icons.emergency,
//                 color: Colors.red,
//                 onTap: () => context.push('/emergency'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchSection() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Buscar Especialista',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.textPrimaryColor,
//                 ),
//           ),
//           const SizedBox(height: 16),
//           SearchBarWidget(
//             onSearch: (query) {
//               // Implementar busca
//               print('Buscar: $query');
//             },
//           ),
//           const SizedBox(height: 16),
//           CategoryFilter(
//             selectedCategory: _selectedCategory,
//             onCategoryChanged: (category) {
//               setState(() => _selectedCategory = category);
//               _filterDoctorsByCategory(category);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUpcomingConsultationsSection() {
//     return Observer(
//       builder: (_) {
//         final consultations = _consultationStore.upcomingConsultations;

//         if (consultations.isEmpty) {
//           return Container(
//             margin: const EdgeInsets.symmetric(
//                 horizontal: AppConstants.defaultPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Próximas Consultas',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.textPrimaryColor,
//                       ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.circular(AppConstants.borderRadius),
//                     border: Border.all(color: AppTheme.borderColor),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.calendar_today_outlined,
//                         size: 48,
//                         color: AppTheme.textSecondaryColor,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Nenhuma consulta agendada',
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   color: AppTheme.textSecondaryColor,
//                                 ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Agende sua primeira consulta',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                               color: AppTheme.textSecondaryColor,
//                             ),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () => context.push('/appointments'),
//                         child: const Text('Agendar Consulta'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Container(
//           margin: const EdgeInsets.symmetric(
//               horizontal: AppConstants.defaultPadding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Próximas Consultas',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: AppTheme.textPrimaryColor,
//                         ),
//                   ),
//                   TextButton(
//                     onPressed: () => context.push('/consultations'),
//                     child: const Text('Ver todas'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 200,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: consultations.length,
//                   itemBuilder: (context, index) {
//                     final consultation = consultations[index];
//                     return Container(
//                       width: 300,
//                       margin: const EdgeInsets.only(right: 16),
//                       child: UpcomingConsultationCard(
//                         consultation: consultation,
//                         onTap: () =>
//                             context.push('/consultation/${consultation.id}'),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStatsSection() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Estatísticas',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.textPrimaryColor,
//                 ),
//           ),
//           const SizedBox(height: 16),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.5,
//             children: [
//               StatsCard(
//                 title: 'Consultas Realizadas',
//                 value: '12',
//                 icon: Icons.medical_services,
//                 color: AppTheme.primaryColor,
//                 trend: '+15%',
//                 isPositive: true,
//               ),
//               StatsCard(
//                 title: 'Médicos Consultados',
//                 value: '8',
//                 icon: Icons.people,
//                 color: Colors.green,
//                 trend: '+20%',
//                 isPositive: true,
//               ),
//               StatsCard(
//                 title: 'Avaliação Média',
//                 value: '4.8',
//                 icon: Icons.star,
//                 color: Colors.amber,
//                 trend: '+0.2',
//                 isPositive: true,
//               ),
//               StatsCard(
//                 title: 'Economia',
//                 value: 'R\$ 240',
//                 icon: Icons.savings,
//                 color: Colors.orange,
//                 trend: '+30%',
//                 isPositive: true,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDoctorsSection() {
//     return Observer(
//       builder: (_) {
//         final doctors = _doctorStore.doctors;

//         if (doctors.isEmpty) {
//           return Container(
//             margin: const EdgeInsets.symmetric(
//                 horizontal: AppConstants.defaultPadding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Médicos em Destaque',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.textPrimaryColor,
//                       ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.circular(AppConstants.borderRadius),
//                     border: Border.all(color: AppTheme.borderColor),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.medical_services_outlined,
//                         size: 48,
//                         color: AppTheme.textSecondaryColor,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Carregando médicos...',
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   color: AppTheme.textSecondaryColor,
//                                 ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Container(
//           margin: const EdgeInsets.symmetric(
//               horizontal: AppConstants.defaultPadding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Médicos em Destaque',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: AppTheme.textPrimaryColor,
//                         ),
//                   ),
//                   TextButton(
//                     onPressed: () => context.push('/doctors'),
//                     child: const Text('Ver todos'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 280,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: doctors.length,
//                   itemBuilder: (context, index) {
//                     final doctor = doctors[index];
//                     return Container(
//                       width: 200,
//                       margin: const EdgeInsets.only(right: 16),
//                       child: DoctorCard(
//                         doctor: doctor,
//                         onTap: () => context.push('/doctor/${doctor.id}'),
//                         onBook: () => context.push('/appointment/${doctor.id}'),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNotificationsSection() {
//     return Container(
//       margin:
//           const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Notificações',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.textPrimaryColor,
//                 ),
//           ),
//           const SizedBox(height: 16),
//           NotificationCard(
//             title: 'Consulta Confirmada',
//             message:
//                 'Sua consulta com Dr. Silva foi confirmada para amanhã às 14h',
//             type: 'success',
//             onTap: () => context.push('/consultation/123'),
//           ),
//           const SizedBox(height: 8),
//           NotificationCard(
//             title: 'Lembrete de Medicamento',
//             message: 'Não esqueça de tomar sua medicação às 20h',
//             type: 'info',
//             onTap: () => context.push('/medications'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _filterDoctorsByCategory(String category) {
//     if (category == 'Todos') {
//       _doctorStore.loadDoctors();
//     } else {
//       _doctorStore.loadDoctorsBySpecialty(category);
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppTheme.errorColor,
//       ),
//     );
//   }
// }
