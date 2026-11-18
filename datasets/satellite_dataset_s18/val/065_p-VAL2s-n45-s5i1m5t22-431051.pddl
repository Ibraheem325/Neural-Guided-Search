(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	spectrograph1 - mode
	infrared4 - mode
	thermograph3 - mode
	image0 - mode
	spectrograph2 - mode
	GroundStation0 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star21 - direction
	GroundStation17 - direction
	Star12 - direction
	GroundStation20 - direction
	GroundStation4 - direction
	Star1 - direction
	Star14 - direction
	GroundStation11 - direction
	Star19 - direction
	GroundStation18 - direction
	GroundStation7 - direction
	GroundStation6 - direction
	Star13 - direction
	GroundStation2 - direction
	Star22 - direction
	Phenomenon23 - direction
	Planet24 - direction
	Star25 - direction
	Phenomenon26 - direction
	Phenomenon27 - direction
	Star28 - direction
	Star29 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation17)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 infrared4)
	(calibration_target instrument1 GroundStation4)
	(calibration_target instrument1 GroundStation20)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star22)
	(supports instrument2 spectrograph2)
	(supports instrument2 thermograph3)
	(calibration_target instrument2 Star14)
	(calibration_target instrument2 Star1)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star13)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 GroundStation18)
	(calibration_target instrument3 Star19)
	(calibration_target instrument3 GroundStation11)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation4)
	(supports instrument4 spectrograph1)
	(supports instrument4 spectrograph2)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 Star13)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 GroundStation7)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation7)
)
(:goal (and
	(pointing satellite1 GroundStation15)
	(pointing satellite2 GroundStation3)
	(pointing satellite3 Planet24)
	(pointing satellite4 GroundStation10)
	(have_image Star22 spectrograph2)
	(have_image Phenomenon23 infrared4)
	(have_image Planet24 infrared4)
	(have_image Star25 spectrograph1)
	(have_image Phenomenon26 infrared4)
	(have_image Phenomenon27 infrared4)
	(have_image Star28 thermograph3)
	(have_image Star29 spectrograph1)
))

)
