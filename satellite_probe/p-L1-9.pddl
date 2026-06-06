(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	infrared2 - mode
	spectrograph1 - mode
	infrared0 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	Planet10 - direction
	Planet11 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation2)
	(supports instrument1 infrared0)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation4)
	(supports instrument2 infrared0)
	(supports instrument2 infrared2)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation9)
	(calibration_target instrument2 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Planet10 infrared0)
	(have_image Planet11 infrared2)
	(have_image Planet12 infrared2)
	(have_image Phenomenon13 spectrograph1)
	(have_image Planet14 infrared0)
))

)
