import sdl2
import opengl
import glu


const WIDTH: cint = 1920
const HEIGHT: cint = 1080
const FRAME_PERIOD: uint32 = 20

var frameTime: uint32 = 0
var window: WindowPtr
proc testDrawTri()

proc init() =
    discard sdl2.init(INIT_EVERYTHING)

    window = createWindow(
        "Arena",
        0, 0,
        WIDTH, HEIGHT,
        SDL_WINDOW_OPENGL or SDL_WINDOW_RESIZABLE
    )
    let ctx = window.glCreateContext()

    # init OpenGL
    loadExtensions()
    glClearColor(0.25, 0.25, 0.25, 1.0)
    glCLearDepth(1.0)
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LEQUAL)
    glShadeModel(GL_SMOOTH)
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

proc resize(newWidth: cint, newHeight: cint) =
    glViewport(0, 0, newWidth, newHeight)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0, newWidth / newHeight, 0.1, 100.0)

proc render() =
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()

    testDrawTri()

    window.glSwapWindow()

proc limitFrameRate() =
    let now = getTicks()

    if frameTime > now:
        delay(frameTime - now)

    frameTime += FRAME_PERIOD

proc startApplication() =
    init()
    resize(WIDTH, HEIGHT)

    var running = true
    var evt = sdl2.defaultEvent

    while running:
        while pollEvent(evt):
            if evt.kind == QuitEvent:
                running = false
                break
            if evt.kind == WindowEvent:
                let windowEvent = cast[WindowEventPtr](addr(evt))
                if windowEvent.event == WindowEvent_Resized:
                    resize(windowEvent.data1, windowEvent.data2)
        render()
        limitFrameRate()

    destroy window


startApplication()

proc testDrawTri() =
    glTranslatef(1.5, 0.0, -7.0)     # Move right and into the screen
    glBegin(GL_TRIANGLES)        # Begin drawing of triangles

    # Top face (y = 1.0f)
    glColor3f(0.0, 1.0, 0.0)     # Green
    glVertex3f( 1.0, 1.0, -1.0)
    glVertex3f(-1.0, 1.0, -1.0)
    glVertex3f(-1.0, 1.0,  1.0)
    glVertex3f( 1.0, 1.0,  1.0)
    glVertex3f( 1.0, 1.0, -1.0)
    glVertex3f(-1.0, 1.0,  1.0)

    # Bottom face (y = -1.0f)
    glColor3f(1.0, 0.5, 0.0)     # Orange
    glVertex3f( 1.0, -1.0,  1.0)
    glVertex3f(-1.0, -1.0,  1.0)
    glVertex3f(-1.0, -1.0, -1.0)
    glVertex3f( 1.0, -1.0, -1.0)
    glVertex3f( 1.0, -1.0,  1.0)
    glVertex3f(-1.0, -1.0, -1.0)

    # Front face  (z = 1.0f)
    glColor3f(1.0, 0.0, 0.0)     # Red
    glVertex3f( 1.0,  1.0, 1.0)
    glVertex3f(-1.0,  1.0, 1.0)
    glVertex3f(-1.0, -1.0, 1.0)
    glVertex3f( 1.0, -1.0, 1.0)
    glVertex3f( 1.0,  1.0, 1.0)
    glVertex3f(-1.0, -1.0, 1.0)

    # Back face (z = -1.0f)
    glColor3f(1.0, 1.0, 0.0)     # Yellow
    glVertex3f( 1.0, -1.0, -1.0)
    glVertex3f(-1.0, -1.0, -1.0)
    glVertex3f(-1.0,  1.0, -1.0)
    glVertex3f( 1.0,  1.0, -1.0)
    glVertex3f( 1.0, -1.0, -1.0)
    glVertex3f(-1.0,  1.0, -1.0)

    # Left face (x = -1.0f)
    glColor3f(0.0, 0.0, 1.0)     # Blue
    glVertex3f(-1.0,  1.0,  1.0)
    glVertex3f(-1.0,  1.0, -1.0)
    glVertex3f(-1.0, -1.0, -1.0)
    glVertex3f(-1.0, -1.0,  1.0)
    glVertex3f(-1.0,  1.0,  1.0)
    glVertex3f(-1.0, -1.0, -1.0)

    # Right face (x = 1.0f)
    glColor3f(1.0, 0.0, 1.0)    # Magenta
    glVertex3f(1.0,  1.0, -1.0)
    glVertex3f(1.0,  1.0,  1.0)
    glVertex3f(1.0, -1.0,  1.0)
    glVertex3f(1.0, -1.0, -1.0)
    glVertex3f(1.0,  1.0, -1.0)
    glVertex3f(1.0, -1.0,  1.0)

    glEnd()  # End of drawing
