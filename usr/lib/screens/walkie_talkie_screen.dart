import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/ptt_button.dart';
import 'dart:async';

class WalkieTalkieScreen extends StatefulWidget {
  const WalkieTalkieScreen({super.key});

  @override
  State<WalkieTalkieScreen> createState() => _WalkieTalkieScreenState();
}

class _WalkieTalkieScreenState extends State<WalkieTalkieScreen> {
  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    // Simulate random incoming transmissions for demo purposes
    _startSimulation();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    // Every 10-20 seconds, simulate someone else talking
    _simulationTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      final appState = Provider.of<AppState>(context, listen: false);
      if (!appState.isTransmitting) {
        appState.simulateIncomingTransmission(true);
        
        // Stop receiving after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
             appState.simulateIncomingTransmission(false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.power_settings_new, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'CHANNEL ${appState.channel}',
          style: GoogleFonts.orbitron(
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.circle,
              size: 12,
              color: appState.isTransmitting 
                  ? Colors.red 
                  : (appState.isReceiving ? Colors.green : Colors.grey),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // LCD Display Area
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A3B2A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF4A5B4A), width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
                const BoxShadow(
                  color: Colors.white10,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SIGNAL', style: GoogleFonts.shareTechMono(color: Colors.black54, fontSize: 10)),
                    Row(
                      children: List.generate(5, (index) => Container(
                        width: 4,
                        height: 8 + (index * 2.0),
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        color: Colors.black87,
                      )),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  appState.isTransmitting 
                      ? 'TRANSMITTING...' 
                      : (appState.isReceiving ? 'RECEIVING...' : 'STANDBY'),
                  style: GoogleFonts.shareTechMono(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'FREQ: 462.${appState.channel}25 MHz',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('USER: ${appState.username.toUpperCase()}', 
                      style: GoogleFonts.shareTechMono(color: Colors.black87, fontSize: 12)),
                    Icon(
                      appState.isTransmitting ? Icons.mic : Icons.mic_off,
                      color: Colors.black54,
                      size: 16,
                    )
                  ],
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Speaker Grid Visual
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.grey.shade900],
              ),
            ),
            child: Center(
              child: GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 20,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const Spacer(),
          
          // PTT Button
          const Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: PTTButton(),
          ),
        ],
      ),
    );
  }
}
