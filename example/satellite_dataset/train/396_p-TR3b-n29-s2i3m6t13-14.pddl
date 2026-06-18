(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	infrared4 - mode
	spectrograph5 - mode
	image1 - mode
	thermograph0 - mode
	image3 - mode
	infrared2 - mode
	Star0 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation3 - direction
	GroundStation8 - direction
	GroundStation1 - direction
	Star9 - direction
	Star13 - direction
	Star14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph0)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
	(supports instrument1 image3)
	(supports instrument1 spectrograph5)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 GroundStation2)
	(supports instrument2 infrared4)
	(calibration_target instrument2 GroundStation3)
	(calibration_target instrument2 GroundStation4)
	(supports instrument3 image1)
	(supports instrument3 infrared2)
	(supports instrument3 spectrograph5)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation1)
	(calibration_target instrument3 GroundStation8)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
)
(:goal (and
	(pointing satellite0 GroundStation7)
	(have_image Star13 thermograph0)
	(have_image Star14 thermograph0)
	(have_image Star14 infrared4)
	(have_image Star15 infrared2)
	(have_image Star15 thermograph0)
	(have_image Phenomenon16 infrared4)
	(have_image Phenomenon16 infrared2)
))

)
