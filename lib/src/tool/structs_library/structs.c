// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// button is number 0, value 0
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "structs.h"


#include <fcntl.h>
#include <unistd.h>
#include <linux/joystick.h>

int read_event(int fd, struct js_event *event)
{
    ssize_t bytes;

    bytes = read(fd, event, sizeof(*event));

    if (bytes == sizeof(*event))
        return 0;

    /* Error, could not read full event. */
    return -1;
}

size_t get_button_count(int fd)
{
    __u8 buttons;
    if (ioctl(fd, JSIOCGBUTTONS, &buttons) == -1)
        return 0;

    return buttons;
}

struct axis_state {
    int axis;
    int x, y;
};

struct axis_state get_axis_state(struct js_event *event, struct axis_state axes)
{
    size_t axis = event->number / 2;

    if (axis < 3)
    {   
        if (event->number % 2 == 0)
            axes.x = event->value;
        else
            axes.y = event->value;
        axes.axis=axis;
    }

    return axes;
}

size_t get_axis_count(int fd)
{
    __u8 axes;

    if (ioctl(fd, JSIOCGAXES, &axes) == -1)
        return 0;

    return axes;
}

char *jsDevice(){
    return "/dev/input/js0";
}



struct buttons{
    int number;
    int value;
};


struct joystickVal{
    int number;
    int value;
    
};


struct joystickState{
    int axis;
    int x,y;
    int number;
    int value;
    int state;
}


struct joystickState joyjoy(){

    struct joystickState state;
    struct js_event event;
    struct axis_state axes;
    size_t axis;

    int js;

    js = open("/dev/input/js0", O_RDONLY);

    // if (read_event(js, &event) == 0)
    read_event(js, &event) 
    // {
        switch (event.type)
        {
            case JS_EVENT_BUTTON:
                // printf("Button %u %s\n", event.number, event.value ? "pressed" : "released");
                // button.number=event.number;
                // button.value=event.value;

                state.number=event.number;
                state.value=event.value;
                state.state=0;

                return state;
                break;
            case JS_EVENT_AXIS:
                axes = get_axis_state(&event, axes);
                
                if (axes.axis < 3)
                    // printf("Axis %zu at (%6d, %6d)\n", axes.axis, axes.x, axes.y);
                    // printf("Axis %zu \n",axis);
                    // axes.axis=axis;
                    // axes.x=axes.x;
                    // axes.y=axes.y;

                    state.axis=axes.axis;
                    state.x=axes.x;
                    state.y=axes.y;
                    state.state=1;
                    return state;

                break;
            default:
                /* Ignore init events. */
                break;
        }
        
        fflush(stdout);
    // }

    close(js);

}


struct axis_state axes(){

    struct joystickState state;
    struct js_event event;
    struct axis_state axes;
    size_t axis;

    int js;

    js = open("/dev/input/js0", O_RDONLY);

    if (read_event(js, &event) == 0)
    // read_event(js, &event) 
    {
        switch (event.type)
        {
            case JS_EVENT_AXIS:
                axes = get_axis_state(&event, axes);
                
                if (axes.axis < 3)
                    printf("Axis %zu at (%6d, %6d)\n", axes.axis, axes.x, axes.y);
                    // printf("Axis %zu \n",axis);
                    // axes.axis=axis;
                    // axes.x=axes.x;
                    // axes.y=axes.y;

                    // state.axis=axes.axis;
                    // state.x=axes.x;
                    // state.y=axes.y;
                    // state.number=0;
                    // state.value=0;
                    
                
                    // state.state=1;
                    return axes;

                break;
            default:
                /* Ignore init events. */
                break;
        }
        
        fflush(stdout);
    }

    close(js);

}

struct buttons button(){
    struct js_event event;
    struct buttons button;

    // struct axis_state axes[3] = {0};
    // size_t axis;

    int js;

    js = open("/dev/input/js0", O_RDONLY);
    // js = open("/dev/input/js0", O_RDONLY);
    
    //  if (read_event(js, &event) == 0)
    read_event(js, &event)
    // {
        // printf(js);
        switch (event.type)
        {
            case JS_EVENT_BUTTON:
                // printf("Button %u %s\n", event.number, event.value ? "pressed" : "released");
                button.number=event.number;
                button.value=event.value;
                return button;
                
                break;
            // case JS_EVENT_AXIS:
            //     axis = get_axis_state(&event, axes);
            //     // if (axis < 3)
            //     //     printf("Axis %zu at (%6d, %6d)\n", axis, axes[axis].x, axes[axis].y);
            //     button.number=0;
            //     button.value=0;
            //     return button;
            //     break;
            default:
                /* Ignore init events. */
                break;
        }
        
        fflush(stdout);
    // }

    close(js);
}

int main()
{
    printf("%s\n", hello_world());
    char* backwards = "backwards";
    printf("%s reversed is %s\n", backwards, reverse(backwards, 9444));

    struct Coordinate coord = create_coordinate(3.5777, 4.68888);
    printf("Coordinate is lat %.2f, long %.2f\n", coord.latitude, coord.longitude);

    struct Place place = create_place("My Home Turkey", 42.0, 24.0);
    printf("The name of my place is %s at %.2f, %.2f\n", place.name, place.coordinate.latitude, place.coordinate.longitude);

    return 0;
}

char *hello_world()
{
    return "Hello World Dunya";
}


char *reverse(char *str, int length)
{
    // Allocates native memory in C.
    char *reversed_str = (char *)malloc((length + 1) * sizeof(char));
    for (int i = 0; i < length; i++)
    {
        reversed_str[length - i - 1] = str[i];
    }
    reversed_str[length] = '\0';
    return reversed_str;
}

void free_string(char *str)
{
    // Free native memory in C which was allocated in C.
    free(str);
}

struct Coordinate create_coordinate(double latitude, double longitude)
{
    struct Coordinate coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    return coordinate;
}

struct Place create_place(char *name, double latitude, double longitude)
{
    struct Place place;
    place.name = name;
    place.coordinate = create_coordinate(latitude, longitude);
    return place;
}

double distance(struct Coordinate c1, struct Coordinate c2) {
    double xd = c2.latitude - c1.latitude;
    double yd = c2.longitude - c1.longitude;
    return sqrt(xd*xd + yd*yd);
}

