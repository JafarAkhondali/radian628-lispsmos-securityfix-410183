#lang racket

(require 
    "../lispsmos-racket/lispsmos.rkt" 
    "../lispsmos-racket/obj-parser.rkt" 
    "../lispsmos-racket/lispsmos-3d.rkt"
    "triangle-intersect.rkt")

(define lispsmos-code `(
    ,@triangle-intersect-formula
    (display (= triangle-point-1 (point 0 0)))
    (display (= triangle-point-2 (point 1 0)))
    (display (= triangle-point-3 (point -0.5 2)))
    (display (= triangle-point-4 (point 0 1)))
    (display (= triangle-point-5 (point 2 0)))
    (display (= triangle-point-6 (point 0 -1)))

    (fn (barycentric-2 p) (to-barycentric
            (.x p) (.y p)
            (.x triangle-point-1) (.x triangle-point-2) (.x triangle-point-3)
            (.y triangle-point-1) (.y triangle-point-2) (.y triangle-point-3)
             
             
        ))

    (= triangle-point-4-2 (barycentric-2 triangle-point-4))
    (= triangle-point-5-2 (barycentric-2 triangle-point-5))
    (= triangle-point-6-2 (barycentric-2 triangle-point-6))

    (display (polygon triangle-point-1 triangle-point-2 triangle-point-3))
    (display (polygon triangle-point-4 triangle-point-5 triangle-point-6))
    (display (polygon triangle-point-4-2 triangle-point-5-2 triangle-point-6-2))
    (display (polygon (get-triangle-triangle-intersection-polygon 
        (point 0 0) (point 1 0) (point 0 1)
        triangle-point-4-2 triangle-point-5-2 triangle-point-6-2
    )))
))

(define compiled-lispsmos-code (compile-lispsmos lispsmos-code))

(require web-server/http web-server/servlet-env)

(define (hello req)
    (response/output
        (lambda (out)
            (display compiled-lispsmos-code out))
            #:headers (list (header #"Access-Control-Allow-Origin" #"*"))
            ))

(serve/servlet hello
#:listen-ip "localhost"
#:port 8080
)