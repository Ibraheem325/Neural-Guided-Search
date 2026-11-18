(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	spectrograph4 - mode
	infrared3 - mode
	infrared1 - mode
	infrared2 - mode
	GroundStation1 - direction
	Star0 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Planet4 - direction
	Phenomenon5 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 infrared2)
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph4)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(have_image Phenomenon2 infrared1)
	(have_image Planet3 infrared2)
	(have_image Planet4 infrared2)
	(have_image Phenomenon5 infrared3)
))

)
