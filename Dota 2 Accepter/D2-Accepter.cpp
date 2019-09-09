//#define _WIN32_WINNT 0x0500
#include <windows.h>
#include <iostream>
// MapVirtualKey(code, MAPVK_VK_TO_VSC);

int main()
{
	HWND handle;
	std::cout << "Looking for Dota 2... ";
	while ((handle = FindWindow(NULL, "Dota 2")) == NULL) {
		Sleep(2000);
	}
	std::cout << "[FOUND]" << std::endl;
	std::cout << "Now switch back to Dota 2 and I will accept any match for you ;)" << std::endl;
	while (true) {
		Sleep(2000);
		if (GetForegroundWindow() != handle) {
			continue;
		}
		//POINT pt;
		//GetCursorPos(&pt);
		//std::cout << pt.x << ',' << pt.y << std::endl;
		// x: 960, y: 540~555
		// Upper left corner is (0, 0) and range is between 0 ~ 65535
		mouse_event(MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE | MOUSEEVENTF_LEFTDOWN, 32768, 33374, 0, 0);
		Sleep(50);
		mouse_event(MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_MOVE | MOUSEEVENTF_LEFTUP, 32768, 33374, 0, 0);
	}
	return 0;
}

