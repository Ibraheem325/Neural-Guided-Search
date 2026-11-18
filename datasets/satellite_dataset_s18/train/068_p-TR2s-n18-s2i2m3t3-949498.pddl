(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	spectrograph1 - mode
	image0 - mode
	infrared2 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Planet3 - direction
	Planet4 - direction
	Phenomenon5 - direction
	Planet6 - direction
	Star7 - direction
	Star8 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet3)
	(supports instrument2 infrared2)
	(calibration_target instrument2 Star1)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation2)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet4)
)
(:goal (and
	(pointing satellite0 Phenomenon5)
	(pointing satellite1 Phenomenon5)
	(have_image Planet3 infrared2)
	(have_image Planet4 spectrograph1)
	(have_image Phenomenon5 image0)
	(have_image Planet6 infrared2)
	(have_image Star7 spectrograph1)
	(have_image Star8 infrared2)
))

)
