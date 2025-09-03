import '../models/user.dart';
import '../models/course.dart';

// Usuario que puede ser tanto estudiante como profesor
class UserWithBothRoles {
  // Constructor de usuario con ambos roles
  const UserWithBothRoles({
    required this.id,
    required this.name,
    required this.email,
    required this.enrolledCourses,
    required this.teachingCourses,
  });

  final String id;
  final String name;
  final String email;
  final List<CourseEnrollment> enrolledCourses;
  final List<Course> teachingCourses;
}

// Servicio de "autenticación"
class AuthService {
  static UserWithBothRoles? _currentUser;

  static UserWithBothRoles? get currentUser => _currentUser;

  static void login() {
    _currentUser = const UserWithBothRoles(
      // Datos de prueba para el usuario "autenticado" en memoria
      id: '1',
      name: 'Juan Pérez',
      email: 'juan.perez@universidad.com',
      enrolledCourses: [
        // Cursos en los que el usuario está inscrito como estudiante
        CourseEnrollment(
          course: Course(
            id: '1',
            name: 'Algoritmos 1',
            professorName: 'Dr. María García',
            description: 'Introducción a algoritmos y estructuras de datos',
          ),
          progress: 75,
        ),
        CourseEnrollment(
          course: Course(
            id: '2',
            name: 'Matemáticas Discretas',
            professorName: 'Prof. Carlos López',
            description: 'Fundamentos de matemáticas para computación',
          ),
          progress: 60,
        ),
        CourseEnrollment(
          course: Course(
            id: '3',
            name: 'Programación Orientada a Objetos',
            professorName: 'Dra. Ana Martínez',
            description: 'Principios de POO con Java',
          ),
          progress: 85,
        ),
        CourseEnrollment(
          course: Course(
            id: '4',
            name: 'Base de Datos',
            professorName: 'Prof. Roberto Silva',
            description: 'Diseño y gestión de bases de datos',
          ),
          progress: 40,
        ),
      ],
      teachingCourses: [
        // Cursos que el usuario imparte como profesor
        Course(
          id: '5',
          name: 'Desarrollo Web Avanzado',
          professorName: 'Juan Pérez',
          description:
              'Desarrollo de aplicaciones web con tecnologías modernas',
        ),
        Course(
          id: '6',
          name: 'Arquitectura de Software',
          professorName: 'Juan Pérez',
          description: 'Patrones y principios de diseño de software',
        ),
        Course(
          id: '7',
          name: 'Machine Learning Básico',
          professorName: 'Juan Pérez',
          description: 'Introducción al aprendizaje automático',
        ),
      ],
    );
  }

  static void logout() {
    _currentUser = null;
  }

  static bool get isLoggedIn => _currentUser != null;
}
