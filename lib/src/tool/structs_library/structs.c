// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// button is number 0, value 0
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
// #include "structs.h"


#include <fcntl.h>
#include <unistd.h>
#include <linux/joystick.h>

int read_event(int fd, struct js_event *event)
{
    ssize_t bytes;

    bytes = read(fd, event, sizeof(*event));
    // printf("%d",*event);
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


// struct axis_state axes(){

//     struct js_event event;
//     struct axis_state axes;
//     int js;

//     js = open("/dev/input/js0", O_RDONLY);

//     while (read_event(js, &event) ==0)
//     {
    
//         switch (event.type)
//         {
//             case JS_EVENT_AXIS:
//                 axes = get_axis_state(&event, axes);
                
//                 if (axes.axis < 3)
//                     // printf("Axis %zu at (%6d, %6d)\n", axes.axis, axes.x, axes.y);
//                     axes.axis=axes.axis;
//                     axes.x=axes.x;
//                     axes.y=axes.y;
//                      return axes;

//                 break;
//             default:
//                 /* Ignore init events. */
//                 break;
//         }
        
//         fflush(stdout);
//     }

//     close(js);

// }

struct axis_state jsevent(){
    struct js_event event;
    // struct buttons button;
    struct axis_state jsbtn;
    int js;

    js = open("/dev/input/js0", O_RDONLY);
    while (read_event(js, &event) ==0)
    {

        // printf("helloss");
        switch (event.type)
        {
            case JS_EVENT_BUTTON:
            // printf(event.value);
                printf("Button %u %s\n", event.number, event.value ? "pressed" : "released");
                jsbtn.axis=event.number;
                if (event.value)
                    jsbtn.x =event.value ? 1:0;
                else
                    jsbtn.x=0;
                // jsbtn.x=event.value ? 1:0;                
                jsbtn.y=-1;    
                return jsbtn;        

                break;
            case JS_EVENT_AXIS:
                jsbtn = get_axis_state(&event, jsbtn);
                
                if (jsbtn.axis < 3)
                    // printf("Axis (%6d, %6d)\n", jsbtn.x, jsbtn.y);
                    jsbtn.axis=jsbtn.axis;
                    jsbtn.x=jsbtn.x;
                    jsbtn.y=jsbtn.y;
                    return jsbtn;
                break;
            default:

                break;
        }

        fflush(stdout);
    }
    close(js);

}

// size_t get_axis_state(struct js_event *event, struct axis_state axes[3])
// {
//     size_t axis = event->number / 2;

//     if (axis < 3)
//     {
//         if (event->number % 2 == 0)
//             axes[axis].x = event->value;
//         else
//             axes[axis].y = event->value;
//     }

//     return axis;
// }

int main(int argc, char *argv[])
{
}

char *hello_world()
{
    return "Hello World Dunya";
}

