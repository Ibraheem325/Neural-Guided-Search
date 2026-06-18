(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	image3 - mode
	image5 - mode
	infrared0 - mode
	infrared2 - mode
	thermograph4 - mode
	spectrograph1 - mode
	GroundStation2 - direction
	GroundStation10 - direction
	Star9 - direction
	GroundStation7 - direction
	GroundStation11 - direction
	Star5 - direction
	GroundStation1 - direction
	GroundStation0 - direction
	GroundStation8 - direction
	Star12 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
)
(:init
	(supports instrument0 image5)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star5)
	(supports instrument1 image3)
	(supports instrument1 infrared0)
	(supports instrument1 image5)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 GroundStation7)
	(supports instrument2 image5)
	(supports instrument2 infrared0)
	(supports instrument2 thermograph4)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument3 image3)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation6)
	(supports instrument4 image5)
	(calibration_target instrument4 GroundStation4)
	(calibration_target instrument4 GroundStation8)
	(calibration_target instrument4 GroundStation0)
	(supports instrument5 image5)
	(supports instrument5 infrared2)
	(calibration_target instrument5 GroundStation6)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 Star12)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation7)
)
(:goal (and
	(have_image Planet13 infrared2)
	(have_image Phenomenon14 thermograph4)
	(have_image Phenomenon15 image3)
	(have_image Phenomenon15 thermograph4)
	(have_image Star16 image5)
	(have_image Star16 image3)
))

)
