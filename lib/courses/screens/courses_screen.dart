import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool showStudentCourses = true;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    // Estructura principal de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF7B2CBF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.home, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    'Cursos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Icono de notificaciones con badge
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      // Badge con número de notificaciones
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  // Avatar del usuario
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF7B2CBF)),
                  ),
                ],
              ),
            ),

            // contenido principal
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido ${user.name}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Today is ${_getCurrentDate()}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // swtich para cambiar entre cursos de estudiante y profesor
                      Row(
                        children: [
                          Text(
                            showStudentCourses
                                ? 'Mis Cursos'
                                : 'Cursos que Imparto',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            showStudentCourses
                                ? 'Ver como profesor'
                                : 'Ver como estudiante',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Switch(
                            value: showStudentCourses,
                            onChanged: (value) {
                              setState(() {
                                showStudentCourses = value;
                              });
                            },
                            activeColor: const Color(0xFF7B2CBF),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // barra de búsqueda estética sin funcionalidad
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            hintText: showStudentCourses
                                ? 'Buscar curso...'
                                : 'Buscar curso que imparto...',
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // lista de cursos
                      Expanded(
                        child: showStudentCourses
                            ? ListView.builder(
                                // ver los cursos en los que el usuario está inscrito como estudiante siguiendo el diseño definido de la
                                //tarjeta accediendo a la lista de enrroled courses
                                itemCount: user.enrolledCourses.length,
                                itemBuilder: (context, index) {
                                  final enrollment =
                                      user.enrolledCourses[index];
                                  return _buildStudentCourseCard(enrollment);
                                },
                              )
                            : ListView.builder(
                                // ver los cursos que el usuario imparte como profesor siguiendo el diseño definido de la tarjeta
                                // accediendo a la lista de teaching courses
                                itemCount: user.teachingCourses.length,
                                itemBuilder: (context, index) {
                                  final course = user.teachingCourses[index];
                                  return _buildTeachingCourseCard(course);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Navegación inferior estética sin funcionalidad
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF7B2CBF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // iconos de navegación
            _buildBottomNavItem(Icons.home, true),
            _buildBottomNavItem(Icons.notifications_outlined, false),
            _buildBottomNavItem(Icons.school_outlined, false),
            _buildBottomNavItem(Icons.menu, false),
          ],
        ),
      ),
    );
  }

  // Tarjeta de curso en la que el usuario está inscrito como estudiante
  Widget _buildStudentCourseCard(CourseEnrollment enrollment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrollment.course.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Profesor: ${enrollment.course.professorName}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: enrollment.progress / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B2CBF),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Progreso: ${enrollment.progress}%',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de curso que el usuario imparte como profesor
  Widget _buildTeachingCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Usted es el profesor',
                  style: TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.settings,
              color: Color(0xFF7B2CBF),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Botón de navegación inferior estético
  Widget _buildBottomNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        color: isActive
            ? Colors.white
            : Colors.white.withAlpha((0.6 * 255).toInt()),
        size: 28,
      ),
    );
  }

  // para dar la fecha actual
  String _getCurrentDate() {
    final now = DateTime.now();
    final weekday = _getWeekdayName(now.weekday);
    final month = _getMonthName(now.month);
    return '$weekday, $month ${now.day}';
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
