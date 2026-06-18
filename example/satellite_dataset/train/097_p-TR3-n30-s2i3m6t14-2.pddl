(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	infrared2 - mode
	thermograph1 - mode
	spectrograph0 - mode
	infrared3 - mode
	image4 - mode
	image5 - mode
	GroundStation0 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	GroundStation8 - direction
	Star12 - direction
	GroundStation7 - direction
	GroundStation10 - direction
	GroundStation4 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	Star14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation8)
	(supports instrument1 infrared3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 GroundStation10)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 GroundStation7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
	(supports instrument3 infrared3)
	(supports instrument3 spectrograph0)
	(supports instrument3 image5)
	(supports instrument3 image4)
	(supports instrument3 thermograph1)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation4)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
)
(:goal (and
	(pointing satellite1 Star12)
	(have_image Star14 infrared3)
	(have_image Phenomenon15 spectrograph0)
	(have_image Star16 spectrograph0)
	(have_image Planet17 infrared3)
	(have_image Planet17 image4)
))

)
