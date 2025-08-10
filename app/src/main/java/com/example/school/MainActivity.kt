package com.example.school

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import dagger.hilt.android.AndroidEntryPoint
import com.example.school.ui.theme.TeacherAppTheme
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.ui.res.stringResource
import com.example.school.navigation.Routes
import com.example.school.ui.screens.*
import androidx.compose.foundation.layout.padding
import androidx.compose.ui.Modifier

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { AppRoot() }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppRoot() {
    TeacherAppTheme {
        val navController = rememberNavController()
        Scaffold(
            topBar = {
                CenterAlignedTopAppBar(
                    colors = TopAppBarDefaults.centerAlignedTopAppBarColors(),
                    title = { Text(text = stringResource(id = R.string.title_dashboard)) }
                )
            }
        ) { innerPadding ->
            NavHost(
                navController = navController,
                startDestination = Routes.DASHBOARD,
                modifier = Modifier.padding(innerPadding)
            ) {
                composable(Routes.DASHBOARD) { DashboardScreen() }
                composable(Routes.CLASSES) { ClassesScreen() }
                composable(Routes.STUDENTS) { StudentsScreen() }
                composable(Routes.ATTENDANCE) { AttendanceScreen() }
                composable(Routes.ASSIGNMENTS) { AssignmentsScreen() }
                composable(Routes.MESSAGES) { MessagesScreen() }
                composable(Routes.SETTINGS) { SettingsScreen() }
            }
        }
    }
}

@Composable
fun DashboardScreen() {
    Text(
        text = stringResource(id = R.string.welcome_message),
        style = MaterialTheme.typography.titleMedium
    )
}

@Preview(showBackground = true)
@Composable
fun AppPreview() {
    AppRoot()
}


